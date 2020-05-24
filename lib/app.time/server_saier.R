#### Time Series Graph
server<-function(input,output){
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

}