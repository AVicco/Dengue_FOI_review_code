// Simple sero-catalytic model
// assumes time- and age-constant FOI
// beta-binomial log likelihood

data {
  
  int<lower=0> N_AgeG; // number of age groups
  real age[N_AgeG]; // age mid-point
  int N[N_AgeG]; // N individuals per age group 
  int NPos[N_AgeG]; // N positive per age group

}

parameters {
  
  real <lower=0.001> lambda; //FOI
  real <lower=0.001> phi; // overdispersion
  
}

transformed parameters {
  
  vector[N_AgeG] z; //seropos
  vector[N_AgeG] a; // standard argument a of the beta function
  vector[N_AgeG] b; // standard argument b of the beta function
  
  
  for(k in 1:N_AgeG) {
    
    z[k] = (1-exp(-lambda*age[k])); //serop
    
    a[k] = z[k] * phi; //prob success
    b[k] = (1-z[k]) * phi; //prob failure
    
  }
  
}

model {
  
  //prior
  lambda ~  normal(0.1, 0.1); 
  phi ~  exponential(1);
  
  //likelihood
  
  for(k in 1:N_AgeG){
    
    target += beta_binomial_lpmf( NPos[k] | N[k],  a[k],  b[k]); 
    
  }
  
}

