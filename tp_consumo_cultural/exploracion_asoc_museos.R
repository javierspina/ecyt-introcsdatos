library(tidyverse)
library(arules)

# Desactivar notacion cientifica
options(scipen=999)

# Leer archivo
encuesta <- read.csv('/Users/javierspina/Documents/jspina/ecyt-introcsdatos/tp_consumo_cultural/encc_2017.csv')

glimpse(encuesta)

encuesta <- encuesta %>% mutate(rango_etario = case_when(
  edad < 21 ~ 'Entre 13 y 20',
  edad <= 35 ~ 'Entre 21 y 35',
  edad <= 50 ~ 'Entre 36 y 50',
  edad <= 65 ~ 'Entre 51 y 65',
  edad > 65 ~ 'Entre 65 y 92',
  TRUE ~ NA_character_
))

# Sacar col X
encuesta$X <- NULL

# Limpieza
encuesta <- encuesta[-c(1950, 2740),]

encuesta$pondera_dem <- as.integer(encuesta$pondera_dem)
encuesta$edad <- as.integer(encuesta$edad)

frecs_museos <- encuesta %>% 
  filter(concurre_museo == 'SI') %>% 
  select(pondera_dem, frec_museo_historicos, frec_museo_cs_naturales, frec_museo_tecnologia, frec_museo_artes, frec_museo_antropologia_arquelogia, frec_museo_tematicos)

frecs_museos <- encuesta %>% 
  filter(concurre_museo == 'SI') %>% 
  select(pondera_dem, frec_museo_historicos, frec_museo_cs_naturales, frec_museo_tecnologia, frec_museo_artes, frec_museo_antropologia_arquelogia, frec_museo_tematicos)


encuesta$frec_museo_historicos[encuesta$frec_museo_historicos == 'VARIAS VECES AL AÑO'] <- 'SI'
encuesta$frec_museo_historicos[encuesta$frec_museo_historicos == 'UNA VEZ AL AÑO'] <- 'SI'

encuesta$frec_museo_historicos[encuesta$frec_museo_historicos == 'NUNCA'] <- 'NO'
encuesta$frec_museo_historicos[encuesta$frec_museo_historicos == 'NS/NC'] <- 'NO'



encuesta$frec_museo_cs_naturales[encuesta$frec_museo_cs_naturales == 'VARIAS VECES AL AÑO'] <- 'SI'
encuesta$frec_museo_cs_naturales[encuesta$frec_museo_cs_naturales == 'UNA VEZ AL AÑO'] <- 'SI'

encuesta$frec_museo_cs_naturales[encuesta$frec_museo_cs_naturales == 'NUNCA'] <- 'NO'
encuesta$frec_museo_cs_naturales[encuesta$frec_museo_cs_naturales == 'NS/NC'] <- 'NO'



encuesta$frec_museo_tecnologia[encuesta$frec_museo_tecnologia == 'VARIAS VECES AL AÑO'] <- 'SI'
encuesta$frec_museo_tecnologia[encuesta$frec_museo_tecnologia == 'UNA VEZ AL AÑO'] <- 'SI'

encuesta$frec_museo_tecnologia[encuesta$frec_museo_tecnologia == 'NUNCA'] <- 'NO'
encuesta$frec_museo_tecnologia[encuesta$frec_museo_tecnologia == 'NS/NC'] <- 'NO'



encuesta$frec_museo_artes[encuesta$frec_museo_artes == 'VARIAS VECES AL AÑO'] <- 'SI'
encuesta$frec_museo_artes[encuesta$frec_museo_artes == 'UNA VEZ AL AÑO'] <- 'SI'

encuesta$frec_museo_artes[encuesta$frec_museo_artes == 'NUNCA'] <- 'NO'
encuesta$frec_museo_artes[encuesta$frec_museo_artes == 'NS/NC'] <- 'NO'




encuesta$frec_museo_antropologia_arquelogia[encuesta$frec_museo_antropologia_arquelogia == 'VARIAS VECES AL AÑO'] <- 'SI'
encuesta$frec_museo_antropologia_arquelogia[encuesta$frec_museo_antropologia_arquelogia == 'UNA VEZ AL AÑO'] <- 'SI'

encuesta$frec_museo_antropologia_arquelogia[encuesta$frec_museo_antropologia_arquelogia == 'NUNCA'] <- 'NO'
encuesta$frec_museo_antropologia_arquelogia[encuesta$frec_museo_antropologia_arquelogia == 'NS/NC'] <- 'NO'


encuesta$frec_museo_tematicos[encuesta$frec_museo_tematicos == 'VARIAS VECES AL AÑO'] <- 'SI'
encuesta$frec_museo_tematicos[encuesta$frec_museo_tematicos == 'UNA VEZ AL AÑO'] <- 'SI'

encuesta$frec_museo_tematicos[encuesta$frec_museo_tematicos == 'NUNCA'] <- 'NO'
encuesta$frec_museo_tematicos[encuesta$frec_museo_tematicos == 'NS/NC'] <- 'NO'


encuesta_museos <- encuesta %>% 
  filter(concurre_museo == 'SI') %>% 
  select(frec_museo_historicos, frec_museo_cs_naturales, frec_museo_tecnologia, frec_museo_artes, frec_museo_antropologia_arquelogia, frec_museo_tematicos, pago_entrada_museo, usa_internet, lee_diarios, escucha_radio, escucha_musica, concurre_teatro, lee_libros, lee_revistas)

encuesta_museos[sapply(encuesta_museos, is.character)] = lapply(encuesta_museos[sapply(encuesta_museos, is.character)], as.factor)

rules <- apriori(encuesta_museos, parameter = c(minlen=3, confidence=0.7))
summary(rules)
inspect(sort(rules, by='lift', decreasing = T)[1:10])

encuesta_museo_hist <- encuesta %>% 
  filter(concurre_museo == 'SI' & razon_ultima_lectura != '') %>% 
  select(usa_internet, razon_ultima_lectura, escucha_musica, lee_libros, frec_museo_historicos, frec_museo_artes, miro_tv, tipo_uso_internet)

encuesta_museo_hist[sapply(encuesta_museo_hist, is.character)] = lapply(encuesta_museo_hist[sapply(encuesta_museo_hist, is.character)], as.factor)

rules_hist <- apriori(encuesta_museo_hist, parameter = c(minlen=3, confidence=0.7))
summary(rules_artes)
inspect(sort(rules_hist, by='lift', decreasing = T)[1:10])





encuesta %>% 
  filter(concurre_museo == 'SI') %>% 
  group_by(rango_etario) %>% 
  summarise(n = n(),
            radio = sum(escucha_radio == 'SI'),
            libros = sum(lee_libros == 'SI'),
            diarios = sum(lee_diarios == 'SI'),
            diarios = sum(lee_diarios == 'SI'),
            internet = sum(usa_internet == 'SI'),
            teatro = sum(concurre_teatro == 'SI'),
            videojuegos = sum(juega_videojuegos == 'SI'),
            facebook = sum(tiene_facebook == 'SI'),
            instagram = sum(tiene_instagram == 'SI'))%>% 
  view()


encuesta %>% 
  filter(concurre_museo == 'SI') %>% 
  ggplot() + 
  geom_density(aes(x=edad, color=NSEcat1)) +
  facet_wrap(~ NSEcat1)


encuesta %>% 
  filter(concurre_museo == 'NO') %>% 
  ggplot() + 
  geom_density(aes(x=edad, color=NSEcat1)) +
  facet_wrap(~ NSEcat1)
