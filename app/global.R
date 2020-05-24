library(shiny)
library(leaflet)
library(leaflet.extras)
library(googleVis)
library(shinydashboard)
library(tidyverse)
library(dplyr)
library(shinyWidgets)
library(ggplot2)
library(lubridate)
library(plotly)

load("arrest_cleaned.RData")

################################################ Global for Time series
pp<-function(data,type,borough,y){
  df<-data %>%
    group_by(year,month,OFNS_DESC,ARREST_BORO) %>%
    count() %>%
    filter(year==y) %>%
    filter(OFNS_DESC==type) %>%
    filter(ARREST_BORO==borough)
  
  g<-ggplot(data=df,mapping = aes(x=month,y=n))+
    geom_point(color="orange",size=10)+
    geom_line(size=2)+
    labs(title = paste("In",as.character(y),"the number of",as.character(type),"happened in",as.character(borough)),
         x="month",
         y="count")+
    scale_x_continuous(breaks = seq(1,12,by=1))+
    theme_light()+
    theme(plot.title = element_text(hjust = 0.5))
  
  return(g)
}

#type is all
tt<-function(data,borough,y){
  df<-data %>%
    group_by(year,month,ARREST_BORO)%>%
    count()%>%
    filter(year==y) %>%
    filter(ARREST_BORO==borough)
  
  g<-ggplot(data=df,mapping = aes(x=month,y=n))+
    geom_point(color="orange",size=10)+
    geom_line(size=2)+
    labs(title = paste("In",as.character(y),"the number of all types of crimes happened in",as.character(borough)),
         x="month",
         y="count")+
    scale_x_continuous(breaks = seq(1,12,by=1))+
    theme_light()+
    theme(plot.title = element_text(hjust = 0.5))
  
  return(g)
}

#borough is all
qq<-function(data,type,y){
  df<-data %>%
    group_by(year,month,OFNS_DESC) %>%
    count() %>%
    filter(year==y) %>%
    filter(OFNS_DESC==type)
  
  g<-ggplot(data=df,mapping = aes(x=month,y=n))+
    geom_point(color="orange",size=10)+
    geom_line(size=2)+
    labs(title = paste("In",as.character(y),"the number of",as.character(type),"happened in all boros"),
         x="month",
         y="count")+
    scale_x_continuous(breaks = seq(1,12,by=1))+
    theme_light()+
    theme(plot.title = element_text(hjust = 0.5))
  
  return(g)
}

#type and borough all are all
aa<-function(data,y){
  df<-data %>%
    group_by(year,month) %>%
    count() %>%
    filter(year==y)
  
  g<-ggplot(data=df,mapping = aes(x=month,y=n))+
    geom_point(color="orange",size=10)+
    geom_line(size=2)+
    labs(title = paste("In",as.character(y),"the number of all types of crimes happened in all boros"),
         x="month",
         y="count")+
    scale_x_continuous(breaks = seq(1,12,by=1))+
    theme_light()+
    theme(plot.title = element_text(hjust = 0.5))
  
  return(g)
}

#########################################################Global for Pie Chart
data <- function(dat){
  arrest.cleaner <- dat %>%
    mutate(YEAR = year(ARREST_DATE))
  return(arrest.cleaner)
}

pie_chart <- function(y, borough, type){
  dat <- arrest.cleaned %>% 
    rename_all(tolower) %>%
    mutate(year = year(arrest_date)) %>%
    mutate(year = sort(year, decreasing = T)) %>% 
    filter(year == y) %>%
    filter(arrest_boro == borough) %>%
    filter(ofns_desc == type)
  
  sex <- dat %>% 
    group_by(perp_sex) %>% count()
  
  race <- dat %>% 
    group_by(perp_race) %>% count()
  
  age <- dat %>% 
    group_by(age_group) %>% count()
  
  colors <- c('rgb(211,94,96)', 'rgb(128,133,133)', 'rgb(144,103,167)', 'rgb(171,104,87)', 'rgb(114,147,203)')
  p <- plot_ly() %>%
    add_pie(data = sex, labels = ~perp_sex, values = ~n,
            textinfo = 'label+percent',
            name = "Sex",
            title = "Perpetrator Sex Distribution Chart",
            marker = list(colors=colors,
                          line = list(color = '#FFFFFF', width = 1)),
            domain = list(x = c(0, 0.4), y = c(0.4, 1))) %>%
    #domain = list(row = 0, column = 0)) %>%
    add_pie(data = race, labels = ~perp_race, values = ~ n,
            #textposition = 'inside',
            textinfo = 'label+percent',
            #insidetextfont = list(color = '#FFFFFF'),
            # hoverinfo = 'text',
            # text = ~paste(perp_race,":", n),
            name = "Race",
            showlegend = T,
            title = "Perpetrator Race Distribution Chart",
            marker = list(#colors=colors,
              line = list(color = '#FFFFFF', width = 1)),
            domain = list(x = c(0.25, 0.75), y = c(0, 0.6))) %>%
    #domain = list(row = 0, column = 1)) %>%
    add_pie(data = age, labels = ~age_group, values = ~ n,
            #textposition = 'inside',
            textinfo = 'label+percent',
            #insidetextfont = list(color = '#FFFFFF'),
            # hoverinfo = 'text',
            # text = ~paste(age_group,":", n),
            name = "Age",
            title = "Perpetrator Age Distribution Chart",
            marker = list(#colors=colors,
              line = list(color = '#FFFFFF', width = 1)),
            domain = list(x = c(0.6, 1), y = c(0.4, 1))) %>%
    #domain = list(row = 0, column = 2)) %>%
    layout(title = "Pie Chart Summary of Perpetrator Data", showlegend = F,
           #grid=list(rows=1, columns=3),
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
  
  return(p)
}