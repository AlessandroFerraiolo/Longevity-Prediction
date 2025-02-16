# Longevity Records Prediction

## Project Overview

This repository contains an analysis and predictive modeling of supercentenarians (individuals aged 110 and above). The project focuses on estimating the number of people reaching this age and predicting when new longevity records might be set in the future. The analysis leverages demographic data and statistical modeling techniques to generate insights into extreme human longevity.

## Disclaimer  

This project was originally a **group assignment** for my **first university statistics course**. As it was my **first exposure to statistical modeling**, I recognize that the problem could have been handled differently using **more advanced models, better-grounded assumptions, or even machine learning techniques**. However, given the course's constraints, the methodology was based on the tools available at the time.  

Additionally, the assignment had the following limitations:  

- **Model selection constraints**: The choices were limited to a predefined set of models. Among them, the **probit model** seemed the most appropriate, but alternative approaches (e.g., Bayesian modeling, survival analysis, or machine learning-based predictions) were not explored.  
- **Report length constraints**: The final document was required to fit within **two pages**, leading to a dense summary of the findings and methodology.  

## Key Findings

- The number of **living 110-year-olds** depends primarily on **total population** and **life expectancy**.
- A **probit regression model** (preferred over logit due to normality assumptions) was used to estimate the number of living 110s based on historical data.
- The model predicts the expected maximum age a supercentenarian might reach in the coming decades.
- Based on simulations, **a new longevity record (age 123) is likely to be set around 2055**.

## Repository Contents

- `R_script.R`: The main R script implementing data processing, modeling, and visualization.
- `R_enviroment.RData`: The dataset and environment required to run the analysis.
- `Longevity records are boundless but rare.pdf`: The original **two-page report** summarizing the findings and methodology.

## Data Sources

- **Human Mortality Database (HMD)**: Provides data on deaths at age 109, used to estimate the number of living 110s.
- **United Nations World Population Prospects (2022)**: Provides historical and projected population and life expectancy data.

## Usage

To replicate the analysis, load the dataset in R and execute the `R_script.R` file. This will generate the predictive models and visualizations.

## License

This project is shared for educational and academic purposes. Feel free to explore and expand upon it, but please cite appropriately if used in research or reports.

---

**Author:** Alessandro Ferraiolo\
**Course:** Statistics\
**Year:** 2024

Special thanks to Carlo C., Veronica C., Alice P., and Roberta C. for their help and support in this project.

