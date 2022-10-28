library(tidyverse)
library(ggplot2)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(gdata)
library(rgdal)

museos <- read.csv('/Users/javierspina/Documents/jspina/ecyt-introcsdatos/tp_consumo_cultural/museos_datosabiertos.csv')

unique(museos$provincia)

world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)
(sites <- data.frame(longitude = c(-80.144005, -80.109), latitude = c(26.479005, 26.83)))

provincias <- read.csv('/Users/javierspina/Documents/jspina/ecyt-introcsdatos/tp_consumo_cultural/provincias.csv')

encuesta <- read.csv('/Users/javierspina/Documents/jspina/ecyt-introcsdatos/tp_consumo_cultural/encc_2017_pars.csv')

consumos <- read.csv('/Users/javierspina/Documents/jspina/ecyt-introcsdatos/tp_consumo_cultural/consumos_culturales.csv')

provs <- st_read('/Users/javierspina/Documents/jspina/ecyt-introcsdatos/tp_consumo_cultural/geo_provincias.json',
                  stringsAsFactors = FALSE)

museos <- museos %>% 
  left_join(provincias, by = 'provincia')

museos <- trim(museos)

museos %>% 
  filter(region == 'CABA') %>% 
  summary(Latitud)


#museos caba
ggplot() +
  geom_sf(data = provs) +
  geom_point(data = filter(museos,region == 'CABA') , aes(x = Longitud, y = Latitud, fill = region), size=2, shape = 23) +
  coord_sf(xlim = c(-59, -58), ylim = c(-35, -24), expand = FALSE)

ggplot(data = world) +
  geom_sf() +
  geom_sf(data = provs, fill = NA) + 
  geom_point(data = museos, aes(x = Longitud, y = Latitud, fill = region), size=2, shape = 23) +
  coord_sf(xlim = c(-78, -50), ylim = c(-56, -20), expand = FALSE) +
  labs(title='Ubicación de los museos de Argentina') +
  facet_wrap(~ region)

encuesta_museo_hist <- encuesta %>% 
  filter(concurre_museo == 'SI' & escucha_musica == 'SI' & miro_tv == 'SI' & frec_museo_historicos != 'NUNCA') %>% 
  select(frec_genero_musica_folclore,	frec_genero_musica_rock_extranjero,	frec_genero_musica_rock_nacional,	frec_genero_musica_clasica,	frec_genero_musica_jazz,	frec_genero_musica_cumbia,	frec_genero_musica_reggaeton,	frec_genero_musica_salsa,	frec_genero_musica_melodica,	frec_genero_musica_pop,	frec_genero_musica_reggae,	frec_genero_musica_electronica,	frec_genero_musica_tango,	frec_genero_musica_latinoamericana)

encuesta_museo_hist[sapply(encuesta_museo_hist, is.character)] = lapply(encuesta_museo_hist[sapply(encuesta_museo_hist, is.character)], as.factor)

rules_hist <- apriori(consumos, parameter = c(minlen=1, confidence=0.8))
summary(rules_hist)
inspect(sort(rules_hist, by='confidence', decreasing = T)[1:10])

