library(tidyverse)
library(nycflights13)

# Analizar la performance de aviones individuales.

inner_join(flights, planes, by='tailnum') %>% 
  glimpse()

inner_join(flights, planes, by='tailnum') %>% 
  inner_join(airports, by=c('origin' = 'faa')) %>% 
  inner_join(airports, by=c('dest' = 'faa')) %>% 
  select(origin, name.x, lat.x, lon.x, dest, name.y, lat.y, lon.y, dep_delay, arr_delay, carrier, tailnum, distance, air_time, type, manufacturer, model, engines, seats, engine) %>% 
  glimpse()
