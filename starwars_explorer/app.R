# To load necessary libraries:
library(shiny)
library(DT)
library(tidyverse)
library(ggplot2)

# Loads the starwars dataset from dplyr package:
data("starwars")

# To preview `starwars` dataset:
head(starwars)

# To preview structure of `starwars` dataset:
glimpse(starwars)

# To preview documentation of `starwars` dataset:
?starwars



# Functional App Features (also available on README file):

### Feature 1 - Filter by Species, Sex, Homeworld, and Film: This feature allows users to create a filtered character table by species, sex, homeworld, and film. It dynamically updates the displayed data based on the selected filters.

### Feature 2 - Scatter Plot of Numeric Relationships: Users can generate a scatter plot to explore relationships between numeric variables (height, mass, and birth year) based on the filtered characters. The plot’s axes can be customized dynamically for in-depth analysis.

### Feature 3 - Vehicles and Starships Information for Filtered Characters: This feature generates a subset of the filtered characters with details on their vehicles and starships, providing users with a focused view of these specific attributes.

### Feature 4 - Bar Plot of Species Distribution by Category: This feature displays a bar plot showing the distribution of individuals from a selected species within the whole dataset, across categories such as homeworld, vehicles, and starships.

# Additional Aesthetic App Feature: A fixed Star Wars logo at the top right of the page to add visual appeal.


# Shiny App Code below: 

# Defines UI for the Shiny app:
ui <- fluidPage(
  
  # App title:
  titlePanel(strong("Star Wars Explorer")),
  
  # Subtitle:
  h5("Explore characters in the Star Wars universe from a galaxy far, far away… Use this interactive tool to filter and visualize data by categories such as species, sex, homeworld, film, and more."),
  
  # Data source credits:
  h6("Data source: This app uses the in-built `starwars` dataset in R from the `dplyr` package."),
  
  # Aesthetic feature: Absolute panel for the Star Wars logo image in the top-right corner
  absolutePanel(
    top = 10, right = 10, fixed = TRUE,
    img(src = "star_wars_logo.png", width = "100px")
  ),
  
  # Sidebar for user input:
  sidebarLayout(
    sidebarPanel(
      # Feature 1: Filter by species, sex, homeworld, and film
      h4("To create a filtered characters table by category*:"),
      selectInput("species_table", "Select Species for table",
                  choices = c("All", unique(starwars$species)), selected = "All"),
      selectInput("sex", "Select Sex",
                  choices = c("All", unique(starwars$sex)), selected = "All"),
      selectInput("homeworld", "Select Homeworld",
                  choices = c("All", unique(starwars$homeworld)), selected = "All"),
      # Since films are vector lists, ensures that only distinct film titles are available:
      selectInput("films", "Select Film",
                  choices = c("All", unique(unlist(starwars$films)))),
      h6(em("*See 'Vehicle and Starship Info' tab for a focused view")),
      
      # Feature 2: Choosing variables for a scatter plot to display relationships
      h4("To create a scatter plot for exploring numeric relationships in your filtered characters:"),
      selectInput("x_var", "Select X-axis Variable",
                  choices = c("height (cm)" = "height",
                              "mass (kg)" = "mass",
                              "birth year (Before Battle of Yavin)" = "birth_year")),
      selectInput("y_var", "Select Y-axis Variable",
                  choices = c("height (cm)" = "height",
                              "mass (kg)" = "mass",
                              "birth year (Before Battle of Yavin)" = "birth_year")),
      
      # Feature 4: Bar plot distribution of a species by a chosen category:
      h4("To find distribution of individuals for a species by category in the whole dataset:"),
      selectInput("category", "Select category",
                  choices = c("homeworld", "vehicles", "starships")),
      selectInput("species_plot", "Select Species for bar plot",
                  choices = unique(starwars$species)),
      
      
      # Added note to account for errors:
      h5(em("NOTE: Selecting categories that are missing for certain characters may result in an error message."))
      
    ),
    
    # Main panel to display table and plots:
    mainPanel(
      tabsetPanel(
        tabPanel("Filtered Data", DTOutput("table")),
        tabPanel("Scatter Plot", plotOutput("scatter_plot")),
        # Feature 3: Convenient and specific table of vehicles and starships for filtered characters:
        tabPanel("Vehicle and Starship Info", DTOutput("character_table")),
        tabPanel("Bar Plot", plotOutput("bar_plot"))
      )
    )
  )
)

# Defines server logic for the Shiny app:
server <- function(input, output, session) {
  
  # Reactive expression to filter data based on user input
  filtered_data <- reactive({
    data <- starwars
    
    if (input$species_table != "All") {
      data <- data %>% filter(species == input$species_table)
    }
    if (input$sex != "All") {
      data <- data %>% filter(sex == input$sex)
    }
    if (input$homeworld != "All") {
      data <- data %>% filter(homeworld == input$homeworld)
    }
    if (input$films != "All") {
      data <- data %>% filter(films == input$films)
    }
    
    return(data)
  })
  
  # Feature 1: Renders the table using DT
  output$table <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 5))
  })
  
  # Feature 2: Renders scatter plot with dynamic axis choices
  output$scatter_plot <- renderPlot({
    data <- filtered_data()
    ggplot(data, aes_string(x = input$x_var, y = input$y_var)) +
      geom_point() +
      labs(x = input$x_var, y = input$y_var, title = paste(input$x_var, "vs", input$y_var)) +
      theme_minimal()
  })
  
  # Defines a reactive expression for the bar plot data based on the full starwars dataset
  grouped_bar_data <- reactive({
    data <- starwars  # Uses the full starwars dataset instead of filtered data
    
    # Filters the data by the selected species
    data <- data %>% filter(species == input$species_plot)
    
    # Groups data by the selected category and count the number of individuals
    grouped_data <- data %>%
      group_by_at(input$category) %>%
      summarise(count = n(), .groups = 'drop')  # Count number of individuals per category
    
    return(grouped_data)
  })
  
  # New reactive expression for character info with vehicles and starships
  character_info <- reactive({
    data <- filtered_data() # Based on the previously filtered data
    
    # Extract vehicles and starships for each character
    character_data <- data %>%
      select(name, vehicles, starships) %>%
      mutate(
        vehicles = sapply(vehicles, function(x) paste(x, collapse = ", ")),
        starships = sapply(starships, function(x) paste(x, collapse = ", "))
      )
    
    return(character_data)
  })
  
  # Feature 3: Renders the table with vehicles and starships for each character filtered by chosen inputs:
  output$character_table <- renderDT({
    datatable(character_info(), options = list(pageLength = 5))
  })
  
  # Feature 4: Renders bar plot with dynamic category choices
  output$bar_plot <- renderPlot({
    data <- grouped_bar_data()
    
    ggplot(data, aes_string(x = input$category, y = "count", fill = input$category)) +
      geom_bar(stat = "identity") +
      scale_fill_brewer(palette = "Set3") +
      labs(x = input$category,
           y = "Number of individuals",
           title = paste("Distribution of", input$species_plot, "by", input$category)) +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, hjust = 1))
  })
}


# Runs the Shiny app:
shinyApp(ui = ui, server = server)