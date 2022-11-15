library(tidyverse)
library(arules)
library(modelr)
library(ggplot2)
options(scipen=999)

# leer dataset
encuesta <- read.csv('C:\\Users\\Javier\\UNSAM\\ecyt-datos\\ecyt-introcsdatos\\tp_consumo_cultural\\data_src\\encc_2017_parsedcols.csv')
museos <- read.csv('C:\\Users\\Javier\\UNSAM\\ecyt-datos\\ecyt-introcsdatos\\tp_consumo_cultural\\data_src\\museos_datosabiertos.csv')
glimpse(encuesta)
problems(encuesta)


# Vista del dataset para mostrar, slide 4
head <- encuesta %>% 
  select(pondera_dem, region, sexo, edad, concurre_museo, frec_museo_historicos, frec_genero_musica_cumbia)


# edad y concurrencia ( no encuentro relacion)
encuesta %>% 
  filter(NSEdenom == '3- Medio' | NSEdenom == '4- Medio-Bajo' | NSEdenom == '5- Bajo') %>% 
  ggplot(aes(x=edad, fill=concurre_museo)) + geom_bar(position = 'fill')
  #ggplot(aes(x=concurre_museo)) + geom_bar()

# nivel de estudios y concurrencia

# grafico de torta mostrando concurrencia a museos de los secundaria incompleta menores de 18
# para argumentar que haciendo excursiones se puede aumentar la concurrencia
# excursiones gratuitas y en escuelas publicas (nse bajos)

encuesta %>%  # quedo  medio feo
  filter(edad < 18, nivel_estudios == 'SECUNDARIA INCOMPLETA') %>% 
  group_by(edad, concurre_museo) %>% 
  summarise(n = sum(pondera_dem)) %>% 
  ggplot(aes(x=edad, y=n, fill=concurre_museo)) +
  geom_col(position='fill') +
  labs(title = 'Concurrencia en estudiantes de secundaria', 
       x = 'Edad',
       y = 'Proporción',
       fill = 'Asistió a museo') +
  theme_minimal() +
  theme(legend.position = 'top')

# distribucion de nses en el dataset

encuesta %>% 
  filter(NSEdenom == '1- Alto' | NSEdenom== '2- Medio-Alto' | NSEdenom=='3- Medio' | NSEdenom=='4- Medio-Bajo' | NSEdenom == '5- Bajo') %>%
  ggplot(aes(y=NSEdenom)) + geom_bar()

# situacion laboral
encuesta %>% 
  mutate(situacion_laboral = case_when(situacion_psh== 'TRABAJA' ~ 'TRABAJA',
                                       situacion_psh== 'ES JUBILADO/PENSIONADO' ~ 'ES JUBILADO/PESIONADO',
                                      (situacion_psh== 'NO TRABAJA PERO TIENE OTROS INGRESOS COMO RENTAS O BECAS' |
                                       situacion_psh == 'NO TRABAJA PERO RECIBE ALGÚN PLAN SOCIAL' |
                                       situacion_psh == 'ESTÁ DESOCUPADO') ~ 'ESTÁ DESOCUPADO')) %>%
  ggplot(aes(x=edad, color=concurre_museo)) + geom_density(size=1) + facet_wrap(~situacion_laboral)


