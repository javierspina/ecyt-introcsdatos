library(tidyverse)
library(arules)

# Desactivar notacion cientifica
options(scipen=999)

# Leer archivo
encuesta <- read.csv('/Users/javierspina/Downloads/TP Consumo Cultural/encc_2017_pars.csv')

glimpse(encuesta)

# Sacar col X
encuesta$X <- NULL

# Limpieza
encuesta <- encuesta[-c(1950, 2740),]

# Crear versión chica
encuesta_corta <- select(encuesta, id, pondera_dem, region, sexo, edad, escucha_radio, escucha_radio_online, escucha_musica, musica_desde_internet, concurre_recitales, practica_musica, lee_diarios, lee_revistas, lee_libros, miro_tv, concurre_cine, concurre_teatro, usa_internet, usa_aplicaciones, tiene_facebook, tiene_instagram, tiene_twitter, tiene_snapchat, tiene_linkedin, juega_videojuegos, NSEcat1)

# Adecuación datos version chica
encuesta_corta$id <- as.integer(encuesta_corta$id)
encuesta_corta$pondera_dem <- as.integer(encuesta_corta$pondera_dem)
encuesta_corta$edad <- as.integer(encuesta_corta$edad)
encuesta_corta[sapply(encuesta_corta, is.character)] = lapply(encuesta_corta[sapply(encuesta_corta, is.character)], as.factor)

# Rules de la encuesta chica
rules <- apriori(encuesta_corta, parameter = c(minlen=3, confidence=0.7))
summary(rules)
inspect(sort(rules, by='lift', decreasing = T)[1:10])

# Exploracion datos encuesta chica
encuesta_corta %>% 
  filter(NSEcat1 != '') %>% 
  group_by(region) %>% 
  mutate(n_hab = sum(pondera_dem), n_enc = n()) %>% 
  ggplot() +
  geom_col(aes(y = region, x = n_enc, fill = NSEcat1)) + 
  labs(title = 'nivel socioeconomico según región')
