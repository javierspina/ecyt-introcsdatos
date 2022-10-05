library(tidyverse)
library(modelr)

arbolado <- read.csv('/Users/javierspina/Documents/jspina/ecyt-introcsdatos/Entrega06/arbolado-publico-lineal-2017-2018.csv')

colnames(arbolado)

mod <- lm(altura_arbol ~ diametro_altura_pecho, data=arbolado)

coef(mod)

grid <- arbolado %>% 
  data_grid(diametro_altura_pecho) %>% 
  add_predictions(mod)

ggplot(arbolado, aes(x=diametro_altura_pecho)) +
  geom_point(aes(y=altura_arbol)) +
  geom_line(aes(y=pred), data=grid, color='red', size=1)
