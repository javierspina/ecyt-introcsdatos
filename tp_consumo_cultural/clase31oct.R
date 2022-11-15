library(tidyverse)
library(arules)
library(modelr)

# Cargar Dataset
encuesta <- read.csv('C:\\Users\\Javier\\UNSAM\\ecyt-datos\\ecyt-introcsdatos\\tp_consumo_cultural\\data_src\\encc_2017_parsedcols.csv')

options(scipen=999)

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
museos <- read.csv('C:\\Users\\Javier\\UNSAM\\ecyt-datos\\ecyt-introcsdatos\\tp_consumo_cultural\\data_src\\museos_region.csv')

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
  geom_line(aes(x=museos_por_hab, y=pred, color=NSEdenom), data=gridE, size=1) +
  labs(title='Entradas expedidas según la cantidad de museos', color = 'NSE', x = 'Museos por región cada 100.000 habitantes', y = 'Entradas expedidas cada 100.000 habitantes')


museos %>% 
  group_by(region, jurisdiccion) %>% 
  count() %>% 
  view()

encuesta %>% 
  filter(concurre_museo == 'SI' & pago_entrada_museo != 'NS/NC') %>% 
  group_by(region, NSEdenom, pago_entrada_museo) %>% 
  summarise(n = sum(pondera_dem)) %>% 
  ungroup() %>% 
  ggplot() +
  geom_point(aes(x=n, y=NSEdenom, color=pago_entrada_museo))

gratis <- encuesta %>% 
  filter(concurre_museo == 'SI' & pago_entrada_museo == 'FUE GRATUITO') %>% 
  group_by(region, NSEdenom) %>% 
  summarise(entrada_gratuita = sum(pondera_dem))

pago <- encuesta %>% 
  filter(concurre_museo == 'SI' & pago_entrada_museo == 'TUVO QUE PAGAR ENTRADA') %>% 
  group_by(region, NSEdenom) %>% 
  summarise(entrada_paga = sum(pondera_dem))

entradas <- left_join(gratis, pago, by=c('region', 'NSEdenom'))

entradas$entrada_paga <- entradas$entrada_paga %>% replace_na(0)

entradas <- encuesta %>% 
  filter(NSEdenom != '') %>% 
  group_by(region, NSEdenom) %>% 
  summarise(habs = sum(pondera_dem)) %>% 
  left_join(entradas, by=c('region', 'NSEdenom'))

entradas$entrada_gratuita <- entradas$entrada_gratuita/entradas$habs*100000
entradas$entrada_paga <- entradas$entrada_paga/entradas$habs*100000

ggplot(entradas) +
  geom_col(aes(x=NSEdenom, y=entrada_paga), size=1)

museos$año_inauguracion <- as.integer(museos$año_inauguracion)

museos %>%
  group_by(año_inauguracion, region) %>% 
  summarise(n_museos = n()) %>% 
  ggplot() +
  geom_col(aes(x=region, y=n_museos))

encuesta %>% 
  group_by(region, concurre_museo) %>% 
  summarise(Encuestados = n(), Ponderación = sum(pondera_dem)/10000) %>% 
  melt(id.vars = c('region', 'concurre_museo')) %>% 
  ggplot() +
  geom_col(aes(x=region, y=value, fill=variable), position='dodge') +
  scale_y_continuous(
    
    # Features of the first axis
    name = "Encuestados",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis(~.*10000, name="Habitantes ponderados")
  ) +
  theme_minimal() +
  theme(legend.position='top', text = element_text(size = 20))+
  labs(title='Magnitud de la ponderación',
       subtitle='Cantidad de encuestados vs ponderación',
       x='Regiones encuestadas', 
       y='Personas',
       fill = '')

itemsets <- read.csv('C:\\Users\\Javier\\UNSAM\\ecyt-datos\\ecyt-introcsdatos\\tp_consumo_cultural\\itemsets.csv')
itemsets_no_concurren <- read.csv('C:\\Users\\Javier\\UNSAM\\ecyt-datos\\ecyt-introcsdatos\\tp_consumo_cultural\\itemsets_no_concurrents.csv')

itemsets['concurre_museo'] <-  'SI'
itemsets_no_concurren['concurre_museo'] <-  'NO'

ggplot(itemsets) +
  geom_tile(aes(x=NSE, y=itemsets, fill=support))

ggplot(itemsets_no_concurren) +
  geom_tile(aes(x=NSE, y=itemsets, fill=support))

prefs <- rbind(itemsets, itemsets_no_concurren)

ggplot(prefs) +
  geom_col(aes(y=itemsets, x=support, fill=concurre_museo), position='dodge') +
  facet_grid(~NSE) +
  labs(title = 'Preferencias sobre otros consumos culturales',
       subtitle='Usando algoritmo Apriori',
       x='Soporte',
       y='',
       fill='Asistió a museo')

encuesta_estudios_simple <- read.csv('C:\\Users\\Javier\\UNSAM\\ecyt-datos\\ecyt-introcsdatos\\tp_consumo_cultural\\data_src\\encuesta_estudios_simple.csv')

encuesta_estudios_simple %>% 
  ggplot() +
  geom_jitter(aes(x=edad, y=nivel_estudios, size=pondera_dem, color=concurre_museo)) +
  facet_wrap(~ concurre_museo) +
  labs(color = 'Asistió a museo', size= 'Ponderador', x='Edad', y='Nivel de Estudios', title='Asistencia a museos según nivel de estudios')

encuesta_estudios_simple %>% 
  filter(NSEdenom != '' & NSEdenom != '6- Marginal') %>% 
  ggplot() +
  geom_jitter(aes(x=edad, y=situacion_psh, size=pondera_dem, color=concurre_museo)) +
  facet_wrap(~ NSEdenom) +
  labs(color = 'Asistió a museo', size= 'Ponderador', x='Edad', y='Situación laboral', title='Asistencia a museos según situación laboral', subtitle='del Principal Sostén del Hogar')

encuesta_estudios_simple %>% 
  group_by(edad) %>% 
  summarise(horas_digitales = mean((horas_internet_total+horas_videojuegos_total)*pondera_dem)/100000) %>% 
  ggplot() +
  geom_point(aes(x=edad, y=horas_digitales))+
  geom_smooth(aes(x=edad, y=horas_digitales)) +
  theme_minimal() +
  labs(title='Consumos digitales según edad', x='Edad', y='Horas promedio cada 100.000 habitantes')

encuesta %>% 
  group_by(NSEdenom) %>% 
  summarise(max_puntaje = max(NSEpuntaje),
            min_puntaje = min(NSEpuntaje))


encuesta$cuantas_veces_concurre_museo <- as.integer(encuesta$cuantas_veces_concurre_museo)

encuesta %>% 
  filter(NSEdenom != '' & NSEdenom != '6- Marginal') %>% 
  group_by(NSEpuntaje) %>% 
  summarise(n_entradas = sum(cuantas_veces_concurre_museo * pondera_dem, na.rm = T),
            n_hab = sum(pondera_dem),
            proporcion_entradas = n_entradas/n_hab) %>% 
  ggplot() +
  geom_point(aes(x=NSEpuntaje, y=n_entradas, color=proporcion_entradas, size=n_hab)) +
  scale_color_gradient(low = "red", high = "green") +
  labs(title='Cantidad de entradas expedidas según NSE',
       x='Puntaje NSE',
       y='Cantidad de Entradas',
       color='Proporción entradas',
       size='Cantidad de Habitantes') +
  theme_minimal()
  
