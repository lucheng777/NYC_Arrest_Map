#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  
  
  
  # Animation 
  
  dt.map.njy <- reactive({
    arrest.cleaned %>%
      mutate(year = year(as.Date(ARREST_DATE,origin = "1970-01-01"))) %>%
      filter(OFNS_DESC %in% input$Ani.crimetype) %>% 
      filter(year %in% input$Ani.time)
  })
  
  
  output$map.njy <- renderLeaflet({
    
    ar.dt_by_date <- dt.map.njy()
    
    ar.dt_by_date %>%
      leaflet(width = "100%") %>%
      addProviderTiles("Esri.WorldTopoMap",
                       options = providerTileOptions(noWrap = T)) %>% 
      setView(lng = -73.99,lat = 40.72,zoom = 11) %>%
      addHeatmap(lng = ar.dt_by_date$Longitude,lat = ar.dt_by_date$Latitude,
                 intensity = ifelse(nrow(ar.dt_by_date)>10,10,
                                    ifelse(nrow(ar.dt_by_date)>5,5,1)),
                 blur = 15, max = 0.05,radius = 10)
    
  })
  
  
  
  
})
