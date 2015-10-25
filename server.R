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

shinyServer(function(input, output, session){
    output$map <- renderLeaflet({
        leaflet() %>%
            setView(lat=-14.5264, lng=-57.8326, zoom=4) %>%
            addTiles() %>%
            addCircleMarkers(data = coordrj, radius = 4)
    })
    
    observeEvent(input$listaUF, {
        coordrj <- coordrj[coordrj$uf == input$listaUF, ]
        if(nrow(coordrj)==0){
            leafletProxy("map")
        } else {
            leafletProxy(mapId = "map") %>% 
                setView(lng = -43.5705, 
                        lat = -22.1766, 
                        zoom = 8)
        }
    })
    
    observeEvent(input$listaMun, {
        coordrjMunic <- coordrjMunic[coordrjMunic$Nome_Munic == input$listaMun, ]
        if(length(coordrjMunic)==0){
            leafletProxy("map")
        } else {
            leafletProxy(mapId = "map") %>% 
                setView(lng = coordrjMunic$lng, 
                        lat = coordrjMunic$lat, 
                        zoom = 12)
        }
    })
    
    observeEvent(input$listaOSC, {
        coordrj <- subset(coordrj, coordrj$razao_social == input$listaOSC)
        if(nrow(coordrj)==0){
            leafletProxy("map")
        } else {
            leafletProxy(mapId = "map") %>% 
                setView(lng = coordrj$lng, 
                        lat = coordrj$lat, 
                        zoom = 18) %>%
                addCircleMarkers(layerId = "layer1",
                                 lng = coordrj$lng, 
                                 lat = coordrj$lat,
                                 color = "black",
                                 fillColor = "orange",
                                 fillOpacity=1, 
                                 opacity=1)
        }
    })
    
    observeEvent(input$voltarMapaOriginal, {
        output$map <- renderLeaflet({
            leaflet() %>%
                setView(lat=-14.5264, lng=-57.8326, zoom=4) %>%
                addTiles() %>%
                addCircles(data = coordrj, radius = 1)
        })
        updateSelectInput(session, "listaUF", selected = "")
        updateSelectInput(session, "listaMun", selected = "")
        updateSelectInput(session, "listaOSC", selected = "")
    })
}
)