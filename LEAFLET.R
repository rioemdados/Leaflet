library(pacman)

p_load(dplyr, leaflet)

df <- read.csv("covid_data.csv")


# MAPA 1 -------------------------------------------------------------------------------------

mapa <- df %>% 
  leaflet() %>% 
  addTiles() 

mapa


# MAPA 2 -------------------------------------------------------------------------------------

mapa <- df %>% 
  leaflet(
    options = leafletOptions(minZoom = 2, 
                             maxZoom = 6)) %>% 
  addProviderTiles(providers$Stamen.Toner, 
                   options = providerTileOptions(opacity = 0.6)) 

mapa


# MAPA 3-------------------------------------------------------------------------------------

mapa <- df %>% 
  filter(date == "2021-09-01") %>% 
  mutate(rad = sqrt(confirmed/max(confirmed)) * 100) %>% 
  leaflet(options = leafletOptions(minZoom = 2, maxZoom = 6)) %>% 
  addProviderTiles(providers$Stamen.Toner, 
                   options = providerTileOptions(opacity = 0.6)) %>%
  addCircleMarkers(lng = ~Longitude, #latitude 
                   lat = ~Latitude, #longitude
                   radius = ~rad, #raio do circulo
                   popup = ~text, #texto interativo
                   weight = 0.7,#grossura da borda do circulo
                   stroke = T, #circulo com borda 
                   color = "#000000", #cor da borda do circulo
                   fillColor = "#79B4B7", #cor que preenche o circulo
                   fillOpacity = 0.3) #opacidade geral

mapa
