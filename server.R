#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
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
library(janitor)


# Define server logic
shinyServer(function(input, output,session) {

  output$Plot1 <- renderPlotly({
    # Plot 1
    # Draw a histogram of age vs number of patients, subsetted by gender of Interest
    levels(indo_rct$gender) <- c("Female", "Male")
    indo_rct_new <- indo_rct %>% 
      filter(age >= input$range[1], age <= input$range[2])
    Plot1 <- ggplot(data = indo_rct_new,
                    aes(x = age, fill = gender)) +
      geom_histogram(bins = input$bins, position = "stack") + 
      labs(x = "Age Range of Interest",
           y = "Number of Patients",
           title = "Histogram of Number of Patients by Age",
           fill = "Gender") +
      theme(plot.title = element_text(hjust = 0.5, face="bold"),
            panel.background = element_blank())
    ggplotly(Plot1)
    
  })
  output$Plot2 <- renderPlotly({
    # Plot 2
    # Rename factors in indo_rct so that our variable name is easier to understand when we plot them
    levels(indo_rct$gender) <- c("Female", "Male")
    levels(indo_rct$sod) <- c("No", "Yes")
    levels(indo_rct$pep) <- c("No", "Yes")
    levels(indo_rct$rx) <- c("Placebo", "Indomethacin")
    levels(indo_rct$outcome) <- c("No PEP", "Has PEP")
    # if-else if statement to make different plots for each user input
    # We cannot vectorize different plot labels so that we need a if-else statement here
    if(input$var == "rx") {
      Plot2 <- indo_rct %>% ggplot() +
        aes(x = indo_rct$rx, y = risk, color = outcome) +
        geom_jitter() +
        theme(legend.position = c(0.85, 0.5)) + 
        labs(x = "Factor of Interest",
             y = "Risk Score", 
             title = "Scatterplot of Different Factors vs. Risk Score") +
        scale_y_continuous(limits = c(0.5,6),
                           breaks = seq(0.5, 6, by = 0.5)) +
        scale_x_discrete(name = "Treatment",
                         position = "top") +
        scale_color_manual(name = "Post-ERCP\nPancreatitis",
                           labels = c("NO", "YES"),
                           values = c("green", "red")) +
        theme_bw() +
        theme(plot.title = element_text(hjust = 0.5, vjust = 1, face="bold")) 
      
    } else if(input$var == "gender") {
      Plot2 <- indo_rct %>% ggplot() +
        aes(x = indo_rct$gender, y = risk, color = outcome) +
        geom_jitter() +
        theme(legend.position = c(0.85, 0.5)) +
        labs(x = "Factor of Interest",
             y = "Risk Score", 
             title = "Scatter Plot of Factor of Interest vs. Risk Score \n Colored by Outcome of Experiment") +
        scale_y_continuous(limits = c(0.5,6),
                           breaks = seq(0.5, 6, by = 0.5)) +
        scale_x_discrete(name = "Gender",
                         position = "top") +
        scale_color_manual(name = "Post-ERCP\nPancreatitis",
                           labels = c("NO", "YES"),
                           values = c("green", "red")) +
        theme_bw() +
        theme(plot.title = element_text(hjust = 0.5, vjust = 1, face="bold")) 
    } else if(input$var == "pep") {
      Plot2 <- indo_rct %>% ggplot() +
        aes(x = indo_rct$pep, y = risk, color = outcome) +
        geom_jitter() +
        theme(legend.position = c(0.85, 0.5)) +
        labs(x = "Factor of Interest",
             y = "Risk Score", 
             title = "Scatter Plot of Factor of Interest vs. Risk Score \n Colored by Outcome of Experiment") +
        scale_y_continuous(limits = c(0.5,6),
                           breaks = seq(0.5, 6, by = 0.5)) +
        scale_x_discrete(name = "Previous post-ERCP pancreatitis (PEP)",
                         position = "top") +
        scale_color_manual(name = "Post-ERCP\nPancreatitis",
                           labels = c("NO", "YES"),
                           values = c("green", "red")) +
        theme_bw() +
        theme(plot.title = element_text(hjust = 0.5, vjust = 1, face="bold")) 
    } else {
      Plot2 <- indo_rct %>% ggplot() +
        aes(x = indo_rct$sod, y = risk, color = outcome) +
        geom_jitter() +
        theme(legend.position = c(0.85, 0.5)) +
        
        labs(x = "Factor of Interest",
             y = "Risk Score", 
             title = "Scatter Plot of Factor of Interest vs. Risk Score \n Colored by Outcome of Experiment") +
        scale_y_continuous(limits = c(0.5,6),
                           breaks = seq(0.5, 6, by = 0.5)) +
        scale_x_discrete(name = "Sphincter of Oddi Dysfunction",
                         position = "top") +
        scale_color_manual(name = "Post-ERCP\nPancreatitis",
                           labels = c("NO", "YES"),
                           values = c("green", "red")) +
        theme_bw() +
        theme(plot.title = element_text(hjust = 0.5, vjust = 1, face="bold")) 
    }
    ggplotly(Plot2)
  })
  # Prepare data for plot 3
  # Remove NA in blood_storage(NA in time_to_recuurence)
  blood_storage <- blood_storage[-191,]
  # Clean Variable names
  blood_storage1 <- blood_storage %>% 
    clean_names() %>% 
      mutate(rbc_age_group = case_when(rbc_age_group == 1 ~ "≤ 13 days (Younger)", # Make var name interpretable
                                       rbc_age_group == 2 ~ "13 - 18 days (Middle)",
                                       rbc_age_group == 3 ~ "≥ 18 days (Older)")
           ) %>% 
    # factor-ize rbc age group
    mutate(rbc_age_group = factor(rbc_age_group,
                                  level = c("≤ 13 days (Younger)",
                                            "13 - 18 days (Middle)",
                                            "≥ 18 days (Older)")))
  # Initialize plot 3
  output$Plot3 <- renderPlotly({
    # Subset data based on user selection
    blood_storage1 <- blood_storage1[blood_storage1$rbc_age_group %in% input$varplot3, ]
    # Make boxplot
    plot3 <- ggplot(blood_storage1,
                    aes(x = rbc_age_group,
                        y = time_to_recurrence,
                        fill = rbc_age_group)) + # Color differently
      geom_boxplot() +
      theme_minimal() +
      theme(legend.position = "none") +
      labs(x = "RBC Storage Duration Time", 
           y = "Time to Biochemical Recurrence of \nProstate Cancer in Month",
           title = "Boxplot of Cancer Recurrence vs. RBC Storage Duration") +
      theme(plot.title = element_text(hjust = 0.5, face="bold")) 
    # make ggplot a plotly one
    ggplotly(plot3)
  })
  
})
