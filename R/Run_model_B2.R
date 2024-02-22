
#########################################################
#
#             CODE TO RUN BETA-BINOMIAL LL MODEL B
#
#########################################################

#Load library
library(cmdstanr)
library(Hmisc)
library("ggpubr")
library(gridExtra)
library(ggplot2)
library(tidyverse)

#Set wd
wd0 <- "data"

#Read your csv file 
df <-read.csv(paste0(wd0, "/data/dataset_modelB.csv"))

#Select the dataset of intereset
loc <- "Chennai, IND [41]"
df_filt <- filter(df, name == loc)

#Specify model inputs into a list
data <- list()
data$N_AgeG <- length(df$mid_age)
data$N <- df$N
data$NPos <- df$N_pos
data$age <- df$mid_age

#Specify model inputs into a list
data <- list()
data$N_AgeG <- length(df$mid_age) #total number of age groups
data$N <- df$N #numnber of individuals tested per age-group
data$NPos <- df$N_pos ##numnber of individuals positive per age-group
data$age <- df$mid_age #mid age point of each age-group

#Fit model
check_cmdstan_toolchain(fix = TRUE)
set_cmdstan_path("C:/Users/av1421/Documents/.cmdstan/cmdstan-2.31.0")

setwd(paste0(wd0, "/script/"))

#BINOM MODEL
mod <- cmdstan_model('Seromodel_B2.stan', pedantic=T)

fit <- mod$sample(data=data, #dengue data
                  chains=3, #number of chains to run
                  parallel_chains=3, #in parallel
                  iter_sampling=5000, #number of iterations to run
                  refresh=500, #to visualise
                  iter_warmup=1000) #warmup step

# check convergence
stanfit <- rstan::read_stan_csv(fit$output_files())
chains <- rstan::extract(stanfit)

traceplot(stanfit, c("lambda", "alpha", "phi"))
fit$cmd_summary()

saveRDS(fit, paste0(wd0, "/output/fit_betabin_age_", loc, ".rds"))

#Calculate statistics from posterior distributions
val_lambda <- c(chains$lambda) #FOI
val_alpha <- c(chains$alpha) #antibody decay
val_phi <- c(chains$phi) #overdispersion

x <- sample(seq(1,15000), 100)  #extract 100 random samples from lambda and alpha
for (i in 1:length(x)){
  val_lambda_samp[i] <- val_lambda[x[i]]
  val_alpha_samp[i] <- val_alpha[x[i]]
  val_phi_samp[i] <- val_phi[x[i]]
}

lambda_stat <- quantile(val_lambda, c(0.5, 0.025, 0.975))
alpha_stat <- quantile(val_alpha, c(0.5, 0.025, 0.975))
phi_stat <- quantile(val_phi, c(0.5, 0.025, 0.975))

#age at 50% serop
age_serop_50 <- -log(1 - (0.5* ((val_lambda_samp + val_alpha_samp) / val_lambda_samp))) /  (val_lambda_samp + val_alpha_samp)
age_serp_50_stat <- quantile(age_serop_50, c(0.5, 0.025, 0.975))

#age at 70% serop
age_serop_70 <- -log(1 - (0.7* ((val_lambda_samp + val_alpha_samp) / val_lambda_samp))) /  (val_lambda_samp + val_alpha_samp)
age_serp_70_stat <- quantile(age_serop_70, c(0.5, 0.025, 0.975))

#age at first infection
age_first <- (1/val_lambda_samp)
age_first_stat <-  quantile(age_first, c(0.5, 0.025, 0.975))

stat <- rbind(lambda_stat, alpha_stat, phi_stat, age_serop_50_stat, age_serop_70_stat,age_first_stat)
colnames(stat) <- c("median", "ciL", "ciU")
write.csv(stat, paste0(wd0, "/output/stat_betabin_age_", loc, ".csv"))



