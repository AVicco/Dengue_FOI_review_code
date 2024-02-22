// Simple sero-catalytic model
// assumes time- and age-constant FOI
// binomial log likelihood

data {
  
  int<lower=0> N_AgeG; // number of age groups
  real age[N_AgeG]; // age mid-point
  int N[N_AgeG]; // N individuals per age group 
  int NPos[N_AgeG]; // N positive per age group
  
}

parameters {
  
  real <lower=0> lambda; //FOI
  real <lower=0> alpha; //antibody decay

}

transformed parameters {
  
  vector[N_AgeG] z; // serop

  
  for(k in 1:N_AgeG) {
    
    z[k] = ((1-exp(-age[k]*(lambda + alpha)))*(lambda/(lambda+alpha)));
    
  }
}

model {
  
  //priors
  lambda ~ normal(0.1,0.1);
  alpha ~ normal(0.1,0.1);
 
  //likleihood

    for(a in 1:N_AgeG){
      target += binomial_lpmf(NPos[a] | N[a], z[a]);
      }
  
  }
  
  
  
  