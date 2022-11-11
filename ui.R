#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(medicaldata)
library(dplyr)
library(ggplot2)
library(plotly)
library(rsconnect)

# Make a navigation bar
navbarPage("Data Challenge 4",
  # make the first tab panel
  tabPanel("Plot 1 & Plot 2",
    h2("Data Visualization for indo_rct dataset",style = "font-family: 'times new roman'; 
       ffont-size: 26px; font-weight: bold"),
    h3("Description of indo_rct dataset:", style = "font-family: 'times new roman'; 
       ffont-size: 26px; font-weight: bold"),
    h5("ERCP, or endoscopic retrograde cholangio-pancreatogram, is a procedure that
       is helpful for treating blockages of flow of bile (gallstones, cancer), or 
       diagnosing cancers of the pancreas, but has a high rate of complications.
       The occurrence of post-ERCP pancreatitis (PEP) is a common and feared complication, 
       as it can cause multisystem organ failure and death, and can occur in around 16% of ERCP 
       procedures. The indo_rct dataset contains the results of a randomized, placebo-controlled, 
       prospective 2-arm trial of indomethacin 100 mg PR once vs. placebo to prevent post-ERCP 
       Pancreatitis in 602 patients. This dataset contains 602 observations and 33 variables.
       ", style = "font-family: 'times new roman'; font-size: 20px"),
    br(),
    # Plot 1
    sidebarLayout(
      # define the sidebar
      sidebarPanel(
        # add instructions for how to use the app
        h4("Description of Plot 1:", style = "font-family: 'times new roman'; font-weight: bold"),
        p("The histogram shows the distribution of patients by age. User can interact with the plot by
          specifying age range of interest. User can also select the number of bins for this histogram.",
          style = "font-family: 'times new roman'"),
        # User input age range of interest, takes in 2 values: min and max
        sliderInput("range", "Age Range of Interest",
                    min = 18, max = 90,
                    value = c(20,90)),
        # User input number of bins for histogram
        sliderInput("bins",
                    "Number of bins:",
                    min = 5,
                    max = 50, 
                    value = 20)
                    ),
      # Show a plot of the generated distribution
      mainPanel(
        tabPanel("Histogram"),
        plotlyOutput("Plot1")
      )
    ),
    br(),
    br(),
    br(),
    # Plot 2
    sidebarLayout(
      sidebarPanel(
        h4("Description of Plot 2:", style = "font-family: 'times new roman'; font-weight: bold"),
        p("The scatterplot shows the relationship between variables (factors) of interest and risk score. We
          are interested in finding out which variable is associated with higher risk score and higher
          prequency of PEP cases. User can choose variable of interest from the select box below.",
          style = "font-family: 'times new roman'"),
        p("Description of Variables:", style = "font-family: 'times new roman'"),
        p("Treatment: Treatment arrangement, whether patient is assigned to placebo or indomethacin",
          style = "font-family: 'times new roman'"),
        p("Gender: Gender of Patient", style = "font-family: 'times new roman'"),
        p("Previous PEP: Previous post-ERCP pancreatitis (PEP), a risk factor for future PEP",
          style = "font-family: 'times new roman'"),
        p("Sphincter of oddi dysfunction: Sphincter of Oddi Dysfunction, a risk factor for future PEP",
          style = "font-family: 'times new roman'"),
        # Input:
        selectInput("var",
                    label = "Variable of Interest",
                    choices = list("Treatment" = "rx", "Gender" = "gender",
                                   "Previous PEP" = "pep", "Sphincter of oddi dysfunction" = "sod"),
                    selected = "Treatment",
                    width = "100%")
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        tabPanel("Scatter Plot"),
        plotlyOutput("Plot2")
      )
    )
  ),
  # make the second tabpanel
  tabPanel("Plot 3",
    h2("Data Visualization for blood_storage dataset",style = "font-family: 'times new roman'; 
       ffont-size: 26px; font-weight: bold"),
    h3("Description of blood_storage dataset:", style = "font-family: 'times new roman'; 
       ffont-size: 26px; font-weight: bold"),
    h5("Radical prostatectomy is known to be among the primary therapies for localized prostate cancer, which 
    in many cases requires blood transfusion. It is suspected that cancer recurrence may be worsened after the 
    transfusion of older blood. The blood_storage dataset comes from a retrospective cohort study done by 
    Cata et al, where he evaluated the association between red blood cells (RBC) storage duration and biochemical 
    prostate cancer recurrence after radical prostatectomy. Specifically, researchers wanted to testthe hypothesis 
    that perioperative transfusion of allogeneic RBCs stored for a prolonged period is associated with earlier 
    biochemical recurrence of prostate cancer after prostatectomy. This dataset contains 316 observations and 20
    variables. ", style = "font-family: 'times new roman'; font-size: 20px"),
    br(),
    # generate a row with a sidebar
    sidebarLayout(
      # define the sidebar
      sidebarPanel(
        # add app instructions
        h4("Description of Plot 3", style = "font-family: 'times new roman'; font-weight: bold"),
        p("This boxplot displays the distribution of Time to Biochemical Recurrence of Prostate Cancer (in month)
        based on RBC storage duration. User can choose to select one or multiple storage time duration groups in 
        order to evaluate their effects on time to cancer recurrence.", style = "font-family: 'times new roman'"),
        # User select 1 or multiple checkboxes
        checkboxGroupInput("varplot3", "RBC Storage Duration Group:",
                           choices = list("≤ 13 days (Younger)" = "≤ 13 days (Younger)",
                                       "13 - 18 days (Middle)" = "13 - 18 days (Middle)" ,
                                       "≥ 18 days (Older)"= "≥ 18 days (Older)"),
                           selected = "≤ 13 days (Younger)"
                           )
                  ),
      # create a spot for the barplot
      mainPanel(
        tabPanel("Boxplot Plot"),
        plotlyOutput("Plot3")
               )
            )
    )
)

