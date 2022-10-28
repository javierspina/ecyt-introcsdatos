library(tidyverse)

#https://datos.gob.ar/dataset/cultura-encuesta-nacional-consumos-culturales-2017

consumo <- read.csv('/home/datascience/Descargas/encc_2017.csv')

consumo <- consumo[-c(1950, 2740),]
consumo$edad <- as.character(consumo$edad)
consumo$edad <- as.integer(consumo$edad)

#PRIMERO FILTRAR POR GRUPO DE EDAD DE INTERES

consumo <- consumo %>% 
  filter(edad <= 35 & edad >=16) #cambiar edades

encuesta <- consumo %>% 
  mutate(rango_etario = case_when(
    edad <= 24 ~ 'Entre 16 y 24',
    edad <= 35 ~ 'Entre 25 y 35'
  ))

encuesta_menores <- encuesta %>% 
  filter(rango_etario == 'Entre 16 y 24')

encuesta_mayores <- encuesta %>% 
  filter(rango_etario == 'Entre 25 y 35')

#ejemplo de como cambiar datos de una columna
encuesta <- encuesta %>%
  mutate(p37 =                           
           replace(p37,
                   p37=="",
                   NA))
# ver cantidad de respuestas
encuesta %>% 
  filter(p1otros == 'DEPORTE') %>% 
  view()

#radio (la hablada va màs enfocada a mayores)
ggplot(encuesta_menores, aes(fill=p2, x = region)) + geom_bar(position = 'dodge') +
  labs(title = 'Radio', subtitle = 'Entre 16 y 24')

ggplot(encuesta_mayores, aes(fill=p2, x = region)) + geom_bar(position = 'dodge') +
  labs(title = 'Radio', subtitle = 'Entre 25 y 35')

#conciertos (enfocar en caba y despues analizamos el tipo de musica)
ggplot(encuesta_menores, aes(fill=p23, x = region)) + geom_bar(position = 'dodge') +
  labs(title = 'Conciertos', subtitle = 'Entre 16 y 24')

ggplot(encuesta_mayores, aes(fill=p23, x = region)) + geom_bar(position = 'dodge') +
  labs(title = 'Conciertos', subtitle = 'Entre 25 y 35')

#diarios (la gràfica va a estar enfocada a mayores y a cuyo, nea y noa)
ggplot(encuesta_menores, aes(fill=p29, x = region)) + geom_bar(position = 'dodge') +
  labs(title = 'Diarios', subtitle = 'Entre 16 y 24')

ggplot(encuesta_mayores, aes(fill=p29, x = region)) + geom_bar(position = 'dodge') +
  labs(title = 'Diarios', subtitle = 'Entre 25 y 35')

#revistas (descartado)
ggplot(encuesta_menores, aes(fill=p37, x = region)) + geom_bar(position = 'dodge') +
  labs(title = 'Revistas', subtitle = 'Entre 16 y 24')

ggplot(encuesta_mayores, aes(fill=p37, x = region)) + geom_bar(position = 'dodge') +
  labs(title = 'Revistas', subtitle = 'Entre 25 y 35')

#tele
ggplot(encuesta_menores, aes(fill=p49, x = region)) + geom_bar(position = 'dodge') +
  labs(title = 'Tele, pelis y series', subtitle = 'Entre 16 y 24')

ggplot(encuesta_mayores, aes(fill=p49, x = region)) + geom_bar(position = 'dodge') +
  labs(title = 'Tele, pelis y series', subtitle = 'Entre 25 y 35')

#internet
ggplot(encuesta_menores, aes(fill=p72, x = region)) + geom_bar(position = 'dodge') +
  labs(title = 'Internet', subtitle = 'Entre 16 y 24')

ggplot(encuesta_mayores, aes(fill=p72, x = region)) + geom_bar(position = 'dodge') +
  labs(title = 'Internet', subtitle = 'Entre 25 y 35')

#HACER TABLA DINAMICA con porcentajes de lo de arriba

encuesta$p76horas <- as.character(encuesta$p76horas)
encuesta$p76minutos <- as.character(encuesta$p76minutos)

encuesta$p76horas <- as.integer(encuesta$p76horas)
encuesta$p76minutos <- as.integer(encuesta$p76minutos)

encuesta %>% 
  mutate(p76= p76horas * 60 + p76minutos) %>% 
  group_by(rango_etario) %>% 
  summarise(prom_internet = mean(p76, na.rm=T)) %>% ungroup() %>% 
  ggplot() + geom_col(aes(x=rango_etario, y = prom_internet, fill = rango_etario)) + 
  labs(title = 'Promedio de tiempo en internet por dìa')










