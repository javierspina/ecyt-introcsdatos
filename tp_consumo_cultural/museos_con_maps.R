library(tidyverse)
library(readxl)

options(scipen=999)


encc_museos <- read.csv('/Users/javierspina/Documents/jspina/ecyt-introcsdatos/tp_consumo_cultural/encc_museos.csv')

encc_museos %>% 
  ggplot() +
  geom_violin(aes(y=NSEcat1, x=NSEpuntaje, fill=concurre_museo, color=concurre_museo))

encc_museos %>% 
  filter(NSEcat1 == 'E') %>% 
  view()

encc_museos %>% 
  filter(razon_ultima_lectura == 'SE LO HABIA RECOMENDADO UN AMIGO, FAMILIAR O CONOCIDO' | razon_ultima_lectura == 'SE LO HABIA RECOMENDADO UN PROFESOR, REFERENTE POLITICO, RELIGIOSO O ESPIRITUAL') %>% 
  ggplot() +
  geom_point(aes(x=edad, y=NSEpuntaje, size=pondera_dem)) +
  facet_wrap(pago_entrada_museo ~ concurre_museo)

warnings(encc_museos)

encuesta <- read.csv('/Users/javierspina/Documents/jspina/ecyt-introcsdatos/tp_consumo_cultural/encc_2017_pars.csv')

encuesta$X <- NULL
encuesta <- encuesta[-c(1950, 2740),]

encuesta <- encuesta %>% mutate(rango_etario = case_when(
  edad < 21 ~ 'Entre 13 y 20',
  edad <= 35 ~ 'Entre 21 y 35',
  edad <= 50 ~ 'Entre 36 y 50',
  edad <= 65 ~ 'Entre 51 y 65',
  edad > 65 ~ 'Entre 65 y 92',
  TRUE ~ NA_character_
))

encuesta$pondera_dem <- as.integer(encuesta$pondera_dem)
encuesta$gasto_museo <- as.integer(encuesta$gasto_museo)

encuesta[sapply(encuesta, is.character)] = lapply(encuesta[sapply(encuesta, is.character)], as.factor)

encuesta %>%
  ggplot() +
  geom_bar(aes(y=region, fill=concurre_museo), position='dodge')

encuesta %>%
  filter(concurre_museo == 'SI') %>% 
  ggplot() +
  geom_bar(aes(y=region, fill=rango_etario), position='fill')

encuesta %>%
  filter(concurre_museo == 'SI') %>% 
  ggplot() +
  geom_bar(aes(y=region, fill=NSEcat1), position='fill')

encuesta %>% 
  group_by(region) %>% 
  summarise(total_gasto_museo = sum(gasto_museo, na.rm=T)) %>% 
  ggplot() +
  geom_col(aes(y=region, x=total_gasto_museo))
