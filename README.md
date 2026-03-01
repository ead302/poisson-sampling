# Poisson Sampling: US Birthweight Analysis (NBER Natality)

## Project Overview
This project implements **Targeted subsampling and Poisson sampling** on the **2013-2024** US Natality dataset. 

The goal is to analyze birthweight distributions using a two-pass streaming approach to calculate global weights ($sum\_w$) and use the weighted samples in downstream tasks.

## Key Features
* **Two-Pass Implementation:** Efficiently calculates sampling weights before the primary sampling pass.
* **Scalable Workflow:** Optimized for both local Mac/Windows use and high-performance computing clusters (ASU SOL).
* **Bias Correction:** Enables debiasing for downstream statistical inference.

## Prerequisites
This analysis was developed using **R 4.3.3**. You will need the following libraries:
```R
install.packages(c("ggplot2", "data.table"))
```

## Data Source
The analysis uses the **NBER Natality Dataset (2013–2024)**. Due to file size constraints (approx. 45GB), the full raw data is not hosted in this repository.

To replicate this analysis:

1. Clone the repository to your local machine, run:
```
git clone https://github.com/ead302/poisson-sampling.git
cd poisson-sampling
```
2. Quick Test: This repo includes a `toy_data/` folder with 1,000 rows per year. The script will run on this demo data automatically if no other `/data` folder is found.
```
source("sampling-birthweight.R")
```
3. Download the `natality2013us.csv` through `natality2024us.csv` files from the [NBER Vital Statistics Data](https://data.nber.org/nvss/natality/csv/) page.
4. Place the downloaded data in a `/data` folder within your local project directory.
5. The script will automatically skip these large files during `git push` thanks to the `.gitignore`.
6. You can also run the main analysis script directly (without cloning) in R using the following command:
```R
source("https://raw.githubusercontent.com/ead302/poisson-sampling/main/sampling-birthweight.R")
```
