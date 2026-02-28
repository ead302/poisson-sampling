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
