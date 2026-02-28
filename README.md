# Poisson Sampling: US Birthweight Analysis (NBER Natality)

## Project Overview
This project implements ** Targeted subsampling and Poisson sampling** on the 2013-2024 US Natality dataset. 

The goal is to analyze birthweight distributions using a two-pass streaming approach to calculate global weights ($sum\_w$) and recover population parameters from weighted samples.

## Key Features
* **Two-Pass Implementation:** Efficiently calculates sampling weights before the primary sampling pass.
* **Bias Correction:** Debiasing in downstream inference.

## Prerequisites
This analysis was developed using **R 4.x**. You will need the following libraries:
```R
install.packages(c("ggplot2","data.table"))
```

Usage
You can run the main analysis script directly in R using the following command:
```R
source("https://raw.githubusercontent.com/ead302/poisson-sampling/main/sampling_birthweight.R")
```

## Data Source
The analysis uses the **NBER Natality Dataset (2021–2022)**. Due to file size constraints, the raw data is not hosted in this repository.

To replicate this analysis:
1. Download the `natl2013.csv` - `natl2022.csv` files from the [NBER Vital Statistics Data](https://data.nber.org/nvss/natality/csv/) page.
2. Place the files in a `/data` folder within your local project directory.
3. The script will automatically skip these files during `git push` thanks to the `.gitignore`.
