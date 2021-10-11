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


# MAPA REELS -------------------------------------------------------------------------------------

vec <- seq.Date(as.Date("2020-03-01"), to = as.Date("2021-09-01"), by = "21 days")
vec <- as.character(vec)

mapa <- df %>% 
  
  # Track the top 20 countries for each date
  group_by(date) %>% 
  
  arrange(desc(confirmed)) %>% 
  
  filter(row_number() <= 50, 
         date %in% vec) %>% 
  
  # Circle radius 
  # Arbitrary scaling function for dramatic effect
  mutate(rad = sqrt(confirmed/max(confirmed)) * 80) %>% 
  
  # Leaflet
  leaflet(options = leafletOptions(minZoom = 2, maxZoom = 6, )) %>% 
  
  # Base map layer
  # Lots of other options see https://rstudio.github.io/leaflet/basemaps.html
  addProviderTiles(providers$Stamen.TonerLite,
                   options = providerTileOptions(opacity = 0.8)) %>%
  
  addCircleMarkers(lng = ~Longitude, 
                   lat = ~Latitude, 
                   radius = ~rad, 
                   popup = ~text,
                   weight = 0.7,
                   stroke = T, 
                   color = "#000000",
                   fillColor = "#525c63", 
                   fillOpacity = 0.5, 
                   group = ~date, 
                   labelOptions = labelOptions(noHide = F)) %>% 
  # Layer control
  addLayersControl(
    
    # Using baseGroups adds radio buttons which makes it easier to switch
    baseGroups = vec,
    
    # Using overlayGroups adds checkboxes        
    # overlayGroups = vec
    
    options = layersControlOptions(collapsed = FALSE))

mapa