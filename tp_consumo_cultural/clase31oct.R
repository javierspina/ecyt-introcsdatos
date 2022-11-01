library(tidyverse)
library(arules)
library(modelr)



# Cargar Dataset
encuesta <- read.csv('~/UNSAM/introduccion_ciencia_datos/Repo/ecyt-introcsdatos/tp_consumo_cultural/data_src/encc_2017_parsedcols.csv')

encuesta$cuantas_veces_concurre_museo <- as.integer(encuesta$cuantas_veces_concurre_museo)
encuesta$gasto_museo <- as.double(encuesta$gasto_museo)

encuesta_filtrada_museo <- encuesta %>% 
  filter(concurre_museo == 'SI')

# modelo nse vs cantidad de veces q fueron al museo
mod <- lm(cuantas_veces_concurre_museo ~ I(NSEpuntaje^2), data = encuesta_filtrada_museo)
summary(mod)

grid <- encuesta_filtrada_museo %>% 
  data_grid(NSEpuntaje,pondera_dem) %>% 
  add_predictions(mod)

encuesta %>% 
  filter(concurre_museo == 'SI') %>% 
  ggplot() +
  geom_jitter(aes(x=NSEpuntaje, y=cuantas_veces_concurre_museo, size=pondera_dem), alpha=0.3) +
  geom_line(data = grid, aes(x=NSEpuntaje, y=pred),color='red', size=1)

encuesta_filtrada_museo <- encuesta_filtrada_museo %>%
  add_residuals(mod)

ggplot(encuesta_filtrada_museo, aes(NSEpuntaje, resid)) +
  geom_line(aes(y = 0), color='red', size=1) +
  geom_jitter(aes(size=pondera_dem), alpha=0.3)


#%% Modelo edad vs cantidad veces museo
mod2 <- lm(cuantas_veces_concurre_museo ~ edad, data = encuesta_filtrada_museo)
summary(mod2)

grid2 <- encuesta_filtrada_museo %>% 
  data_grid(edad) %>% 
  add_predictions(mod2)

encuesta %>% 
  filter(concurre_museo == 'SI') %>% 
  ggplot() +
  geom_jitter(aes(x=edad, y=cuantas_veces_concurre_museo, size=pondera_dem), alpha=0.3) +
  geom_line(data = grid2, aes(x=edad, y=pred), size=1)


# modelo nse vs gasto en museo
mod3 <- lm(gasto_museo ~ NSEpuntaje, data = encuesta_filtrada_museo)
summary(mod3)

grid3 <- encuesta_filtrada_museo %>% 
  data_grid(NSEpuntaje) %>% 
  add_predictions(mod3)

encuesta %>% 
  filter(concurre_museo == 'SI') %>% 
  ggplot() +
  geom_jitter(aes(x=NSEpuntaje, y=gasto_museo, size=pondera_dem), alpha=0.3) +
  geom_line(data = grid3, aes(x=NSEpuntaje, y=pred),color='red', size=1)


# Variable x: cantidad de museos en la region
museos <- read.csv('~/UNSAM/introduccion_ciencia_datos/Repo/ecyt-introcsdatos/tp_consumo_cultural/data_src/museos_region.csv')

glimpse(museos)

museos_por_reg <- museos %>% 
  group_by(region) %>% 
  summarise(cantidad_museos = n())

hab_por_reg <- encuesta %>% 
  group_by(region) %>% 
  summarise(popul = sum(pondera_dem))

museos_por_reg <- museos_por_reg %>% 
  left_join(hab_por_reg, by='region') %>% 
  mutate(museos_por_hab = cantidad_museos/popul*100000)

write_csv(museos_por_reg, '~/UNSAM/introduccion_ciencia_datos/Repo/ecyt-introcsdatos/tp_consumo_cultural/data_src/cantidad_museos_region.csv')

ggplot(museos_por_reg) +
  geom_point(aes(x=region, y=cantidad_museos))

entradas_proporcional <- encuesta %>% 
  filter(NSEdenom != '' & NSEdenom != '6- Marginal') %>% 
  group_by(region, NSEdenom) %>% 
  summarise(n_hab = sum(pondera_dem),
            cant_entradas = sum(cuantas_veces_concurre_museo * pondera_dem, na.rm = T),
            entradas_por_hab = cant_entradas/n_hab*100000)

entradas_proporcional <- entradas_proporcional %>% 
  left_join(museos_por_reg, by='region')
  
entradas_proporcional %>% 
ggplot() +
  geom_point(aes(x = museos_por_hab, y=entradas_por_hab, color=NSEdenom))

modE <- lm(entradas_por_hab ~ museos_por_hab * NSEdenom, data=entradas_proporcional)
summary(modE)

gridE <- entradas_proporcional %>% 
  data_grid(museos_por_hab, NSEdenom) %>% 
  add_predictions(modE)

ggplot(entradas_proporcional)+
  geom_point(aes(x=museos_por_hab, y=entradas_por_hab, color=NSEdenom)) +
  geom_line(aes(x=museos_por_hab, y=pred, color=NSEdenom), data=gridE) +
  labs(title='Entradas expedidas según la cantidad de museos', subtitle = 'En cada región de Argentina, cada 100.000 habitantes', color = 'Nivel Socio Económico', x = 'Cantidad de museos por región', y = 'Cantidad de entradas expedidas')
