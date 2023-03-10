#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(palmerpenguins)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Penguin size relationships"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            textInput(inputId = "species",
                      label= "Species",
                      value = "Gentoo")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot"),
           tableOutput("statsTable")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  # Create size plot for penguin species
    output$distPlot <- renderPlot({
      ggplot(data = penguins[penguins$species == input$species, ], 
             mapping = aes(x = bill_length_mm, 
                           y = bill_depth_mm,
                           color = sex)) +
        geom_point() +
        xlab("Bill length (mm)") +
        ylab("Bill depth (mm)")       
    })
    
    # Add results of a linear model to output
    output$statsTable <- renderTable({
      # Create the linear model
      model <- lm(formula = bill_depth_mm ~ bill_length_mm,
                  data = penguins[penguins$species == input$species, ])
      # Extract summary statistics
      model_summary <- summary(model)
      # Print coefficient table
      model_summary$coefficients
    }, rownames = TRUE)
}

# Run the application 
shinyApp(ui = ui, server = server)
