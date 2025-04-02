# Analysis-Data-Covid-19-in-Indonesia

This project focuses on analyzing the COVID-19 data in Indonesia, specifically examining the trends and patterns observed in West Java province. The analysis is performed using R and covers multiple aspects of the pandemic, including daily cases, recovery rates, and deaths.

## Features
- COVID-19 Data Analysis: Utilizes R to analyze and visualize various COVID-19 data points in Indonesia.
- Focus on West Java: Detailed study cases and trend analysis for the West Java region, including data from 2020-2022.
- Visualizations: Multiple plots illustrating the dynamics of COVID-19 cases, including daily positive cases, deaths, and recovery rates.

## Files
- API.R: Script for fetching and processing COVID-19 data.
- StudyCaseForAPI.R: Script for analyzing COVID-19 data specific to study cases.
- Plots: Various graphical representations of the data trends, including daily positive cases, recoveries, and deaths in West Java.

## Installation
Clone this repository and run the provided R scripts to start analyzing COVID-19 data.
- git clone https://github.com/AdityaAnanta123/Analysis-Data-Covid-19-in-Indone

## Packages Used
- tidyverse: A collection of packages for data manipulation (dplyr, tidyr) and visualization (ggplot2).
- lubridate: Used for parsing and manipulating date-time data.
- scales: Helps format axis labels and numbers for better readability.
- plotly (optional): For creating interactive visualizations.

## Visualization Process
- Data Preparation: Raw COVID-19 data is cleaned and reshaped using functions like gather() and mutate() from tidyverse.
- Time Series Analysis: Data is aggregated by date and missing values are handled.
- Creating Plots: Line or bar plots are created using ggplot2 to show daily cases, deaths, recoveries, and cumulative data.
- Enhancing Visuals: Labels, titles, and axis formatting are added for clarity.
- Interactive Plots: Optional use of plotly to add interactivity to visualizations.
