
shinyServer(function(input, output, session) {

  # The data frame for the map
  df.map <- reactive({
    arrest.cleaned %>%
      filter(OFNS_DESC %in% input$Map.crimetype) %>%
      filter(ARREST_DATE <= input$Map.endtime) %>%
      filter(ARREST_DATE >= input$Map.starttime)
  })

  # The data frame for interaction between INPUTs
  df.map.updateselect <- reactive({
    arrest.cleaned %>%
      filter(ARREST_DATE <= input$Map.endtime) %>%
      filter(ARREST_DATE >= input$Map.starttime)
  })

  # output$test <- renderText(df.map.updateselect()$OFNS_DESC %>% as.character() %>% unique() %>% sort())

  observeEvent(input$Map.starttime, {
    update.crimetype.zrz <- df.map.updateselect()$OFNS_DESC %>% unique() %>% sort()
    updateSelectInput(session,
                      "Map.crimetype",
                      choices = update.crimetype.zrz,
                      selected = update.crimetype.zrz[1])
    if(input$Map.starttime > input$Map.endtime){
      updateDateInput(session,
                      "Map.endtime",
                      value = as.Date(input$Map.starttime, origin = "1970-01-01"),
                      min = min(arrest.cleaned$ARREST_DATE),
                      max = max(arrest.cleaned$ARREST_DATE))
    }
  })

  observeEvent(input$Map.endtime, {
    update.crimetype.zrz <- df.map.updateselect()$OFNS_DESC %>% unique() %>% sort()
    updateSelectInput(session,
                      "Map.crimetype",
                      choices = update.crimetype.zrz,
                      selected = update.crimetype.zrz[1])
    if(input$Map.endtime < input$Map.starttime){
      updateDateInput(session,
                      "Map.starttime",
                      value = as.Date(input$Map.endtime, origin = "1970-01-01"),
                      min = min(arrest.cleaned$ARREST_DATE),
                      max = as.Date(input$Map.endtime, origin = "1970-01-01"))
    }
  })

  output$map.zrz <- renderLeaflet({

    centerColor <- function(dt){
      sapply(dt$LAW_CAT_CD, function(juris) {
        if(juris == "Others") {
          "white"
        } else if(juris == "Housing") {
          "brown"
        } else if(juris == "Transit"){
          "green"
        } else{
          "black"
        } })
    }

    iconColor <- function(quakes) {
      sapply(quakes$LAW_CAT_CD, function(off) {
        if((off == "Violation") | (off == "Infraction")) {
          "yellow"
        } else if(off == "Misdemeanor") {
          "orange"
        } else {
          "red"
        } })
    }

    icons <-
      awesomeIcons(
        icon = 'ios-close',
        iconColor = centerColor(df.map()),
        library = 'ion',
        markerColor = iconColor(df.map())
      )

    map <- leaflet(data = df.map()) %>%
      addProviderTiles("Esri.WorldTopoMap",
                       options = providerTileOptions(noWrap = T)) %>%
      setView(-73.974224, 40.761052,zoom = 12) %>%
      addResetMapButton() %>%
      addAwesomeMarkers(~Longitude,
                        ~Latitude,
                        label = ~as.character(OFNS_DESC),
                        popup = ~ paste0("<b>",ARREST_DATE,"</b>",
                                         "<br/>", "Crime Type: ", OFNS_DESC,
                                         "<br/>", "Level of Offence: ", LAW_CAT_CD,
                                         "<br/>", "Juriscition: ", JURISDICTION_CODE,
                                         "<br/>", "Gendar: ", PERP_SEX,
                                         "<br/>", "Age: ", AGE_GROUP,
                                         "<br/>", "Race: ", PERP_RACE),
                        icon = icons)
    map
  })

  #### Time Series Graph
  df.timeseries<-reactive({
    arrest.cleaned %>%
      mutate(year=year(ARREST_DATE),
             month=month(ARREST_DATE))
  })
  output$ggplot<-renderPlot({
    y<-input$year
    type<-input$choice_type
    borough<-input$choice_borough

    if(type=="ALL"&borough=="ALL"){
      return(aa(data=df.timeseries(),y=y))
    }else if(type=="ALL"&borough!="ALL"){
      return(tt(data=df.timeseries(),borough=borough,y=y))
    }else if(type!="ALL"&borough=="ALL"){
      return(qq(data=df.timeseries(),type=type,y=y))
    }else{
      return(pp(data=df.timeseries(),type = type,borough=borough,y=y))
    }
  })

  ######## Pie Chart Page
  output$plot <- renderPlotly({
    y<-input$choose_year
    type<-input$choose_type
    borough<-input$choose_borough
    pie_chart(y = y, borough = borough, type = type)
  })

  ######### Animation
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
