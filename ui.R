library(shiny)
library(leaflet)
library(sp)
library(plotGoogleMaps)
library(ggmap)
library(maptools)
library(foreign)

load("coordrj.Rda")
coordrj <- coordrj[, c(1, 2, 4, 8)]
coordrj$razao_social <- as.character(coordrj$razao_social)
coordrj$razao_social <- enc2utf8(coordrj$razao_social)

load("coordrjMunic.Rda")
coordrjMunic <- coordrjMunic[, c(1, 4, 10, 11)]
coordrjMunic$Nome_Munic <- as.character(coordrjMunic$Nome_Munic)
coordrjMunic$Nome_Munic <- enc2utf8(coordrjMunic$Nome_Munic)

shinyUI(navbarPage("CSOs Map - Brazil",
           tabPanel("Interactive Map",
                    div(class="outer", 
                        tags$head(includeCSS("./www/estilos.css")),
                        leafletOutput("map", width="100%", height="100%"), 
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = T, draggable = TRUE, 
                                      top = 60, left = "auto", right = 20, bottom = "auto", width = 330, 
                                      height = "auto", 
                                      
                                      h2("Explore the map"), 
                                      
                                      selectInput("listaUF", label = "State",
                                                  choices = c("", levels(factor(coordrj$uf))), 
                                                  selected = ""),
                                      selectInput("listaMun", label = "City", 
                                                  choices = c("", levels(factor(coordrjMunic$Nome_Munic))), 
                                                  selected = ""), 
                                      selectInput("listaOSC", label = "Organization", 
                                                  choices = c("", levels(factor(coordrj$razao_social))), 
                                                  selected = ""), 
                                      actionButton("voltarMapaOriginal", label = "Return to the default map")))),
           tabPanel("About", 
                    mainPanel(includeMarkdown("about.Rmd"))
                    )
           )
)