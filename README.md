[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/_WsouPuM)

# Shiny App: Star Wars Explorer

This repository contains the necessary files to deploy the "Star Wars Explorer" Shiny app for STAT 545B Assignment B3. The app allows users to explore the Star Wars universe and its characters, providing interactive tools to filter, visualize, and analyze data by categories such as species, sex, homeworld, films, and more.

**Dataset Source:** The app uses the in-built `starwars` dataset in R studio from the `dplyr` package. This dataset contains fictional data on characters from the Star Wars universe.

## Options to access the app:

1.  **Online Version:** Click [here](https://andreawk.shinyapps.io/starwars_explorer/) to open the Shiny app in your web browser, or paste the following link: <https://andreawk.shinyapps.io/starwars_explorer/> into your browser.

2.  **Local Version:** Run the app in RStudio by executing the `app.R` file locally.

## App Features:

-   **Feature 1 - Filter by Species, Sex, Homeworld, and Film**: This feature allows users to create a filtered character table by species, sex, homeworld, and film. It dynamically updates the displayed data based on the selected filters.

-   **Feature 2 - Scatter Plot of Numeric Relationships:** Users can generate a scatter plot to explore relationships between numeric variables (height, mass, and birth year) based on the filtered characters. The plot’s axes can be customized dynamically for in-depth analysis.

-   **Feature 3 - Vehicles and Starships Information for Filtered Characters**: This feature generates a subset of the filtered characters with details on their vehicles and starships, providing users with a focused view of these specific attributes.

-   **Feature 4 - Bar Plot of Species Distribution by Category:** This feature displays a bar plot showing the distribution of individuals from a selected species within the whole dataset, across categories such as homeworld, vehicles, and starships.

-   **Feature 5 - Download Filtered Data by Species, Sex, and/or Homeworld:** Users can download a `.csv` file containing the filtered character data from Feature 1. Note that the film filter is excluded for code simplicity.

## Repository Contents:
- **README.md**: This file, providing instructions and information about the app, dataset source, and features.
- **starwars_explorer**: The folder that contains all the relevant files for the "Star Wars Explorer" shiny app, such as:  
  - **app.R**: The main R script that contains all the code to run the app, including UI and server components for interactive filtering, visualization, and analysis of the Star Wars dataset.
  - **www**: A folder containing additional assets, such as the Star Wars logo.
  - **Other files and folders**: This includes setup or configuration files and folders (e.g., `rsconnect/shinyapps.io/andreawk`) used for deployment, which can be ignored for general usage.

Feel free to explore the Star Wars universe through this interactive tool - may the force be with your data exploration!
