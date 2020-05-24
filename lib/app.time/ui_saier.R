library(shiny)
library(shinydashboard)


#load(file="../app/arrest.RData")


ui <-dashboardPage(
      skin = "red",
      
      dashboardHeader(title = "arrest"),
      
      dashboardSidebar(
        sidebarMenu(
          menuItem("Menu1", tabName = "Menu1"),
          menuItem("Menu2", tabName = "Menu2"),
          menuItem("TimeSeries", tabName = "TimeSeries"),
          menuItem("Menu4", tabName = "Menu4")
        )
      ),
      
      dashboardBody(
        tabItems(
          #
          tabItem(tabName = "Menu1",
                  fluidPage(
                  )
          ),
          
          #
          tabItem(tabName = "Menu2",
                  fluidPage(
                  )
          ),
          
          #
          tabItem(tabName = "TimeSeries",
                  fluidPage(
                    fluidRow(
                      column(6,
                             sliderInput(inputId = "year",label = "Choose a year",value = 2012,step=1,min = 2006,max = 2018)),
                      
                      column(6,
                             selectInput(inputId = "choice_type",label ="choose a type",
                                         choices =c(unique(as.character(arrest.cleaned$OFNS_DESC)),"ALL"))),
                      
                      column(6,
                             selectInput(inputId = "choice_borough",label = "choose a borough",choices =c(unique(arrest.cleaned$ARREST_BORO),"ALL")))
                    ),
                    
                    fluidRow(
                      plotOutput(outputId = "ggplot",height = "600px")
                    )
                  )
          ),
          
          #
          tabItem(tabName = "Menu4",
                  fluidPage(
                  )
          )
        
      )
    
  )

)


shinyApp(ui=ui,server=server)
