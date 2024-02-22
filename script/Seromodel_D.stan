// Simple sero-catalytic model
// assumes time- and age-constant FOI
// normal likelihood for PRNT data

data {
  
  int nA; //number of age-groups
  vector[nA] p1A; //% positivity DENV1
  vector[nA] p2A; //% positivity DENV2
  vector[nA] p3A; //% positivity DENV3
  vector[nA] p4A; //% positivity DENV4
  vector[nA] age; // mid-age point
  
}

parameters {
  real <lower=0> lambda1; // DENV1 FOI
  real <lower=0> sigma1; // DENV1 serop sd
  real <lower=0> lambda2; // DENV2 FOI
  real <lower=0> sigma2; // DENV2 serop sd
  real <lower=0> lambda3; // DENV3 FOI
  real <lower=0> sigma3; // DENV3 serop sd
  real <lower=0> lambda4; // DENV4 FOI
  real <lower=0> sigma4; // DENV4 serop sd
  
}

transformed parameters {
  
  vector[nA] EpA1; // serop DENV1
  vector[nA] EpA2; // serop DENV2
  vector[nA] EpA3; // serop DENV3
  vector[nA] EpA4; // serop DENV4
     
  for(a in 1:nA) EpA1[a] = 1 - exp(-lambda1*age[a]);
  
  for(a in 1:nA) EpA2[a] = 1 - exp(-lambda2*age[a]);
  
  for(a in 1:nA) EpA3[a] = 1 - exp(-lambda3*age[a]);
  
  for(a in 1:nA) EpA4[a] = 1 - exp(-lambda4*age[a]);
  
}



model {
  
  // priors
  lambda1 ~ normal(0.1,0.1);
  sigma1 ~ normal(0,1);
  lambda2 ~ normal(0.1,0.1);
  sigma2 ~ normal(0,1);
  lambda3 ~ normal(0.1,0.1);
  sigma3 ~ normal(0,1);
  lambda4 ~ normal(0.1,0.1);
  sigma4 ~ normal(0,1);
  
  // model
  p1A ~ normal(EpA1, sigma1);
  p2A ~ normal(EpA2, sigma2);
  p3A ~ normal(EpA3, sigma3);
  p4A ~ normal(EpA4, sigma4);
  
}



generated quantities {
  
  // median FOI for DENV
  real lambda = (lambda1 + lambda2 + lambda3 + lambda4) / 4;
  
}
