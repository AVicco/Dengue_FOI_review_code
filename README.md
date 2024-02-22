# Dengue_FOI_review_code

This repository contains age-stratified seroprevalence data for dengue, obtained through a comprehensive literature review. The pre-print publication detailing the methodology and findings can be found here (DOI: https://doi.org/10.1101/2023.04.07.23288290).

**Data Files**
In each file the "location" column specifies the location where the data was collected and the referenced paper.

    dataset_modelA.csv: Contains the seroprevalence data analyzed with Model A.
    dataset_modelB.csv: Contains the seroprevalence data analyzed with Model B. 
    dataset_modelC.csv: Contains the seroprevalence data analyzed with Model C. 
    dataset_model_D.csv: Contains the seroprevalence data analyzed with Model D. 
    dataset_Madagascar.csv: Contains the seroprevalence data analyzed with Model A in Madagascar.
    dataset_Mexico.csv: Contains the seroprevalence data analyzed with Model A in Mexico.
    dataset_Indonesia.csv: Contains the seroprevalence data analyzed with Model A in Indonesia.

**Usage**

Each model (Model A, B, C, and D) has its own R script and Stan model files that need to be executed to analyze the respective dataset. For Model A and B, the numeration 1 and 2 are used to separate the use of a binomial (1) or beta-binomial (2) log-likelihood. Ensure you have the necessary dependencies installed before running the scripts, the analysis was run in CmdStanR.

    Model A1:
        Script: Run_model_A1.R
        Stan Model: Seromodel_A1.stan
    Model A2:
        Script: Run_model_A2.R
        Stan Model: Seromodel_A2.stan
    Model B1:
        Script: Run_model_B1.R
        Stan Model: Seromodel_B1.stan
    Model B2:
        Script: Run_model_B2.R
        Stan Model: Seromodel_B2.stan
    Model C:
        Script: Run_model_C.R
        Stan Model: Seromodel_C.stan
    Model D:
        Script: Run_model_D.R
        Stan Model: Seromodel_D.stan

Refer to the individual scripts for specific instructions on how to execute the analysis for each model.
