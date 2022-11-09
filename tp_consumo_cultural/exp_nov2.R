library(tidyverse)
library(ggplot2)

# Desactivar notacion cientifica
options(scipen=999)

# Leer archivo
encuesta <- read.csv('/Users/javierspina/Documents/jspina/ecyt-introcsdatos/tp_consumo_cultural/data_src/encc_2017_parsedcols.csv')

# Categorizar edades
encuesta <- encuesta %>% mutate(grupo_etario = case_when(
  edad <= 18 ~ 'Entre 13 y 18',
  edad <= 30 ~ 'Entre 19 y 30',
  edad <= 40 ~ 'Entre 31 y 40',
  edad <= 50 ~ 'Entre 41 y 50',
  edad <= 60 ~ 'Entre 51 y 60',
  edad <= 75 ~ 'Entre 61 y 75',
  edad > 75 ~ 'Mayor a 75',
  TRUE ~ NA_character_
))

# https://r-graph-gallery.com/79-levelplot-with-ggplot2.html

# %%%%% Concurrencia a museos según grupo etario y nivel de estudios
concurrencia_edades_estudios <- encuesta %>% 
  group_by(concurre_museo, grupo_etario, nivel_estudios) %>% 
  summarise(n_hab = sum(pondera_dem))

ggplot(concurrencia_edades_estudios) +
  geom_tile(aes(x=grupo_etario, y=nivel_estudios, fill=n_hab)) +
  scale_fill_gradient() +
  facet_grid(~ concurre_museo)


# %%%%% Concurrencia a museos según grupo etario y NSE
concurrencia_edades_nse <- encuesta %>% 
  filter(NSEdenom != '6- Marginal' & NSEdenom != '') %>% 
  group_by(concurre_museo, grupo_etario, NSEdenom) %>% 
  summarise(n_hab = sum(pondera_dem))

ggplot(concurrencia_edades_nse) +
  geom_tile(aes(x=grupo_etario, y=NSEdenom, fill=n_hab)) +
  scale_fill_gradient() +
  facet_grid(~ concurre_museo)

# %%%%% Concurrencia a museos según grupo etario y region
concurrencia_edades_region <- encuesta %>% 
  group_by(concurre_museo, grupo_etario, region) %>% 
  summarise(n_hab = sum(pondera_dem))

ggplot(concurrencia_edades_region) +
  geom_tile(aes(x=grupo_etario, y=region, fill=n_hab)) +
  scale_fill_gradient() +
  facet_grid(~ concurre_museo)

