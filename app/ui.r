ui <-
    dashboardPage(
      skin = "red",
      
      dashboardHeader(title = "NYC Arrest Data",
                      dropdownMenu(type = "messages",
                                   messageItem(from = "Data Resource",
                                               message = "NYC OPEN DATA",
                                               icon = icon("database"))
                                   )),
      
      dashboardSidebar(
        sidebarMenu(
          menuItem("Map", tabName = "Map", icon = icon("map-marked-alt"),
                   menuSubItem("Crime Map", tabName = "Map"),
                   menuSubItem("Heat Map", tabName = "Animation")),
          menuItem("TimeSeries", tabName = "TimeSeries", icon = icon("shoe-prints")),
          menuItem("PieChart", tabName = "PieChart", icon = icon("chart-pie")),
          menuItem("More Info", tabName = "MoreInfo", icon = icon("info"))
        )
      ),
      
      dashboardBody(
        tags$style(type="text/css",
                        ".shiny-output-error { visibility: hidden; }",
                        ".shiny-output-error:before { visibility: hidden; }"
        ),
        
        tabItems(
          tabItem(tabName = "Map",
                  fluidRow(
                    box(
                      width = 3,
                      height = 80,
                      dateInput("Map.starttime",
                                "Start Time",
                                value = "2018-01-01",
                                min = min(arrest.cleaned$ARREST_DATE),
                                max = max(arrest.cleaned$ARREST_DATE))
                    ),
                    box(
                      width = 3,
                      height = 80,
                      dateInput("Map.endtime",
                                "End Time",
                                value = "2018-01-31",
                                min = min(arrest.cleaned$ARREST_DATE),
                                max = max(arrest.cleaned$ARREST_DATE))
                    ),
                    box(
                      width = 6,
                      height = 80,
                      selectInput("Map.crimetype",
                                  "Type of Crime",
                                  choices = sort(unique(arrest.cleaned$OFNS_DESC)),
                                  selected = "drug dealing",
                                  multiple = T)
                    )
                  ),# select boxes end here
                  fluidRow(
                    box(
                      width = 12,
                      height = 700,
                      ## The output is Here!
                      leafletOutput("map.zrz", height = 680)
                    )
                  ) # map box
          ),
          
          tabItem(tabName = "TimeSeries",
                  fluidPage(
                    fluidRow(
                      column(6,
                             sliderInput(inputId = "year",label = "Choose a year",value =max(year(arrest.cleaned$ARREST_DATE)),step=1,
                                         min = min(year(arrest.cleaned$ARREST_DATE)),max = max(year(arrest.cleaned$ARREST_DATE)))),
                      
                      column(6,
                             selectInput(inputId = "choice_type",label ="choose a type",
                                         choices =c(sort(unique(as.character(arrest.cleaned$OFNS_DESC))),"ALL"))),
                      
                      column(6,
                             selectInput(inputId = "choice_borough",label = "choose a borough",
                                         choices =c(sort(unique(arrest.cleaned$ARREST_BORO)),"ALL")))
                    ),
                    
                    fluidRow(
                      plotOutput(outputId = "ggplot",height = "600px")
                    )
                  )
          ),
          tabItem(tabName = "PieChart",
                  fluidPage(
                    fluidRow(
                      # year
                      column(6,
                             selectInput(inputId = "choose_year",label ="choose a year",
                                         choices = unique(as.character(data(arrest.cleaned)$YEAR)) %>% sort())
                      ),
                      # borough
                      column(6,
                             selectInput(inputId = "choose_borough",label ="choose a borough",
                                         choices = unique(as.character(data(arrest.cleaned)$ARREST_BORO)))
                      ),
                      # crime type
                      column(6,
                             selectInput(inputId = "choose_type",label ="choose a type",
                                         choices = unique(as.character(data(arrest.cleaned)$OFNS_DESC)))
                      ),
                    ),
                    fluidRow(
                      plotlyOutput("plot"), align="center"
                    )
                  )
          ),
          
          tabItem(tabName = "Animation",
                  fluidRow(
                    box(
                      width = 6,
                      height = 80,
                      selectInput(inputId = "Ani.crimetype", label = "Crime Type",
                                  choices = sort(unique(arrest.cleaned$OFNS_DESC)),
                                  selected = "drug dealing",
                                  multiple = F)
                    ),
                    absolutePanel(top = 50, right = 20,
                                  sliderInput("Ani.time", "Year", min = min(year(as.Date(arrest.cleaned$ARREST_DATE,origin = "1970-01-01"))), 
                                              max = max(year(as.Date(arrest.cleaned$ARREST_DATE,origin = "1970-01-01"))), 
                                              value = c(min(year(as.Date(arrest.cleaned$ARREST_DATE,origin = "1970-01-01"))),min(year(as.Date(arrest.cleaned$ARREST_DATE,origin = "1970-01-01")))), 
                                              step = 1, 
                                              animate = animationOptions(interval = 2000, loop = FALSE)))
                  ),
                  fluidRow(
                    box(
                      width = 12,
                      height = 700,
                      leafletOutput("map.njy", height = 680)
                    )
                  ) # map
          ),
          
          tabItem(tabName = "MoreInfo",
                  fluidPage(
                    fluidRow(
                      box(
                        width = 12,
                        title = "The Problem (Motivation)",
                        h5("  New York City is huge metropolis, attracting people from around the world, and an important issue for many living (or those wanting to live) in NYC is public safety.  Crime occurs all the time: from assaults to murders to grand larceny to drunk driving. Residents, visitors, police officials, and policy makers should be better informed of which areas are more likely to be dangerous, what types of crime are more likely to occur, and what times of the year crime is likely; however, it is not always easy for average people to find this information. It is our hope that this app will remedy this by making information on crime more accessible.")
                      )
                    ),
                    fluidRow(
                      box(
                        width = 12,
                        title = "The Solution",
                        h5("  Our shiny app is based on the official NYPD arrest records in New York City of the last 5 years (2013-2018).  The target users for this project, include residents, the NYPD and Policy Makers. Through our app, residents can know where different kinds of criminals appear and are arrested during each year and each borough, so that they can be informed of when and where criminals are more likely to appear and keep away from such areas. For police, given the past data, they can make predictions as to when and where different types of criminals will appear and try their best to catch them and maintain public safety. Policy makers will be able to study demographics of the arrests (age, gender, and race) for different types of crimes, different years, and boroughs and determine whether unfair bias exists based on different boroughs such as racism and gender inequality.")
                      )
                    ),
                    fluidRow(
                      box(
                        width = 12,
                        title = "The Details",
                        h4("Our NYC Arrest Data App features 3 primary functions:"),
                        tags$div(tags$ul(
                          tags$li("Map - Crime Map: Shows locations and specific details of each arrest (date, jurisdiction, crime type, and level of offense) within a specified range of time.  The users can also search for crimes by type."),
                          tags$li("Map - Heat map: Shows animated density of arrests made each year by crime type."),
                          tags$li("TimeSeries: Shows a time-series plot of the number of crimes over 12 months. The plot can change by specifying the year, crime type, and borough."),
                          tags$li("Pie Chart: Shows three different pie charts that detail the arrest demographics (sex, race, and age) by year, crime type, and borough. ")
                        ))
                      )
                    ),
                    fluidRow(
                      box(
                        width = 12,
                        title = "Developers",
                        h5("Ruozhou Zhang, Saier Gong, Jiayun Ni, Lu Cheng, Tianning Yu, Heagy David")
                      )
                    )
                  )
          )
          
          
          
        )
      )
    )



