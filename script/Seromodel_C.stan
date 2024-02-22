// Simple sero-catalytic model
// assumes time- and age-constant FOI
// normal likelihood for serop data with no info on positive or tested

data {
  
  int nA; //number of age-groups
  vector[nA] pA; // % serop
  vector[nA] age; // mid-age point
  
}

parameters {
  real <lower=0> lambda; //FOI
  real <lower=0> sigma; // serop sd
}

transformed parameters {
  
  vector[nA] EpA; //serop
  
  for(a in 1:nA) EpA[a] = 1 - exp(-lambda*age[a]);
  
}



model {
  
  // priors
  lambda ~ normal(0.1,0.1);
  sigma ~ normal(0,1);
  
  // model
  pA ~ normal(EpA, sigma);
}

