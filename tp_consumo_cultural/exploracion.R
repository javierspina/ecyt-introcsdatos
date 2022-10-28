library(tidyverse)

# leer dataset
encuesta <- read.csv('/Users/javierspina/Downloads/TP Consumo Cultural/encc_2017.csv')

glimpse(encuesta)
problems(encuesta)

# limpieza de datos. Las filas 1950 y 2740 tienen sus datos mal ingresados.
encuesta <- encuesta[-c(1950, 2740),]

# adecuación de datos generales
encuesta$edad <- as.integer(encuesta$edad)
encuesta$id <- as.integer(encuesta$id)
encuesta$sexo <- as.factor(encuesta$sexo)
encuesta$region <- as.factor(encuesta$region)
encuesta$fecha <- as.Date(encuesta$fecha, format = '%d/%m/%Y')

# Desagregar los tópicos de las encuestas
# Estos quizá no nos resultan útiles
# encuesta_cine <- select(encuesta, id, p63, p63_1, p63_1otr, p63_2, p64, p65, p65_bis, p65_1, p65_1_bis, p66, p66otros, p67_1, p67_2, p67_3, p67_4, p67_5, p67_6, p67_7, p67_8, p67_9, p67_10, p67_11)

encuesta_cine <- select(encuesta, id, p63, p63_1, p63_1otr, p63_2, p64, p65, p65_1, p66, p66otros, p67_1, p67_2, p67_3, p67_4, p67_5, p67_6, p67_7, p67_8, p67_9, p67_10, p67_11)

colnames(encuesta_cine) <- c('id', 'concurrio_cine', 'motivo_no_cine', 'otro_motivo_no_cine', 'acostumbro_ir_cine', 'frec_cine', 'cuantas_veces_cine', 'cuantas_peliculas_arg', 'razon_eleccion_pelicula', 'otra_razon_eleccion_pelicula', 'frec_accion', 'frec_aventura', 'frec_scifi', 'frec_suspenso', 'frec_terror', 'frec_drama', 'frec_comedia', 'frec_romantico', 'frec_documental', 'frec_infantiles', 'frec_animacion')

#encuesta_comunidad <- select(encuesta, id, p92_1, p92_2, p92_3, p92_4, p92_5, p92_6, p92_7, p92_8, p92_9, p93_1, p93_2, p93_3, p93_4, p94_1, p94_2, p94_3, p94_4, p94_5, p94_6, p95, p96_1, p96_2, p96_3, p96_4, p96_5, p97, p97_bis)

#encuesta_libros <- select(encuesta, id, p42, p42_1, p42_1otr, p42_2, p43, p43_bis, p43_1, p43_1_bis, p44, p44otros, p45, p45_bis, p45_1, p45_1_bis, p46, p47,p47_1a, p47_1b, p47_1c, p47_1d, p47_2, p48_1, p48_2, p48_3, p48_4, p48_5, p48_6, p48_7, p48_8, p48_9, p48_10, p48_11, p48_12, p48_13, p48_14, p48_15, p48_16)

encuesta_libros <- select(encuesta, id, p42, p42_1, p42_1otr, p42_2, p43, p43_1, p44, p44otros, p45, p45_1, p46, p47,p47_1a, p47_1b, p47_1c, p47_1d, p47_2, p48_1, p48_2, p48_3, p48_4, p48_5, p48_6, p48_7, p48_8, p48_9, p48_10, p48_11, p48_12, p48_13, p48_14, p48_15, p48_16)

colnames(encuesta_libros) <- c('id', 'leyo_libros', 'razon_no_lee', 'otra_razon_no_lee',  'acostumbro_leer', 'cuantos_libros', 'libros_autorxs_arg', 'razon_ultima_lectura', 'otra_razon_ultima_lectura', 'cuantos_libros_compro', 'cuanto_gasto_libros', 'frec_libros_papel', 'frec_libros_pantalla', 'frec_leer_dispositivo_a', 'frec_leer_dispositivo_b', 'frec_leer_dispositivo_c', 'frec_leer_dispositivo_d', 'pago_lectura_dispositivos', 'frec_cuentos', 'frec_novelas', 'frec_poesia', 'frec_ensayos', 'frec_escolares', 'frec_biografias', 'frec_teatro', 'frec_ciencia', 'frec_comics', 'frec_humor', 'frec_autoayuda', 'frec_historia', 'frec_politica', 'frec_salud', 'frec_divulgacion', 'frec_otros')

#encuesta_patrimonio <- select(encuesta, id, p98, p99, p99_bis, p100_1, p100_2, p100_3, p100_4, p100_5, p100_6, p101, p102, p102_bis, p103_1, p103_1_1,p103_2, p103_1_2, p103_3, p103_1_3, p103_4, p103_1_4, p103_5, p103_1_5, p103_6, p103_1_6, p103_7, p103_1_7, p103_8, p103_1_8, p103_9, p103_1_9, p103_10, p103_110,p103_11, p103_111, p103_12, p103_112, p103_13, p103_113, p103_14, p103_114, p103_15, p103_115, p103_16, p103_116, p103_17, p103_117, p103_18, p103_118,p103_19, p103_119, p103_20, p103_120)

#encuesta_teatro <- select(encuesta, id, p68, p69, p70, p70_bis, p70_1, p70_1_bis, p71, p71_bis)

# Estos nos pueden interesar
# Demografia
encuesta_demografia <- select(encuesta, id, region, sexo, edad, p104, p104_1, p104_2, p105, p106, p107, p108, p109, p110, p110b, p111, p111b, p112, p113_1, p113_2, p113_3, p113_4, p113_5, p114, p115_1, p115_2, p115_3, p115_4, p115_5, p116, p116b, p117) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

colnames(encuesta_demografia) <- c('id', 'region', 'sexo', 'edad', 'cant_convivientes', 'convivientes_menores15', 'convivientes_mayores65', 'cantidad_habitaciones', 'nivel_estudios', 'jefx_hogar', 'nivel_estudios_jefx', 'situacion_jefx', 'ocupacion_jefx', 'cat_ocupacion_jefx', 'cat_ocupacion_jefx2', 'cat_ocupacion_jefx3', 'cobertura_medica_jefx', 'hogar_tiene_internet', 'hogar_tiene_1auto', 'hogar_tiene_mas1auto', 'hogar_hay_tarjeta_credito', 'hogar_hay_celular', 'situacion_vivienda', 'limitacion_convivientes_vision', 'limitacion_convivientes_audicion','limitacion_convivientes_desplazarse',  'limitacion_convivientes_motriz', 'limitacion_convivientes_cognitiva', 'tipo_barrio', 'tipo_barrio2', 'tipo_vivienda')

encuesta_baile <- select(encuesta, id, p95)

colnames(encuesta_baile) <- c('id', 'fue_a_bailar')

encuesta_datos <- select(encuesta, id, region, sexo, edad)

# Categorizar edades
encuesta_datos <- encuesta_datos %>% mutate(rango_etario = case_when(
  edad < 16 ~ 'Entre 13 y 15',
  edad <= 21 ~ 'Entre 16 y 21',
  edad <= 27 ~ 'Entre 22 y 27',
  edad <= 35 ~ 'Entre 28 y 35',
  edad <= 45 ~ 'Entre 36 y 45',
  edad <= 55 ~ 'Entre 46 y 55',
  edad <= 65 ~ 'Entre 56 y 65',
  edad > 65 ~ 'Mayor a 65',
  TRUE ~ NA_character_
))

# Radio
# encuesta_radio_todos_los_campos <- select(encuesta, id, p2, p2_1, p2_1otro, p2_2, p3, p4, p5, p6horas, p6minutos, horas_radio, minutos_radio, p7_1, p7_2, p7_3, p7_4, p7_5, p8a, p8b, p8c, p8d, p8e, p8f, p8g, p8otros, p9, minutos_radio_1, minutos_radio_total, horas_radio_total) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

encuesta_radio <- select(encuesta, id, p2, p2_1, p2_1otro, p2_2, p3, p4, p5, p7_1, p7_2, p7_3, p7_4, p7_5, p8a, p8b, p8c, p8d, p8e, p8f, p8g, p8otros, p9, minutos_radio_total, horas_radio_total) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

colnames(encuesta_radio) <- c('id', 'escucha_radio', 'motivo_no_radio', 'otro_motivo_no_radio', 'acostumbro_escuchar_radio','radio_online', 'frec_escucho_radio', 'am_o_fm', 'radio_estero', 'radio_auto', 'radio_computadora', 'radio_celular', 'radio_tablet', 'tipo_programa_a', 'tipo_programa_b', 'tipo_programa_c', 'tipo_programa_d', 'tipo_programa_e', 'tipo_programa_f', 'tipo_programa_g', 'tipo_programa_otros', 'cuantos_equipos', 'minutos_radio_total', 'horas_radio_total')

# Televisión, peliculas y series
# encuesta_audiovisual_todos_los_campos <- select(encuesta, id, p49, p49_1, p49_2, p50horas, p50minutos, horas_TV, minutos_TV, p51a, p51b, p52, p53, p54_1, p54_2, p54_3, p54_4, p55_1, p55_2, p55_3, p56, p56_1, p56_1_bis, p57, p57_1, p57_1otr, p57_2, p58_1, p58_2, p58_3, p58_4, p58_5, p58_6, p58_7, p59_1, p59_2, p59_3, p59_4, p59_5, p59_6, p60, p61, p62, minutos_tv_1, minutos_tv_total, horas_tv_total) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

encuesta_audiovisual <- select(encuesta, id, p49, p49_1, p49_2, p51a, p51b, p52, p53, p54_1, p54_2, p54_3, p54_4, p55_1, p55_2, p55_3, p56, p56_1, p57, p57_1, p57_1otr, p57_2, p58_1, p58_2, p58_3, p58_4, p58_5, p58_6, p58_7, p59_1, p59_2, p59_3, p59_4, p59_5, p59_6, p60, p61, p62, minutos_tv_total, horas_tv_total) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

colnames(encuesta_audiovisual) <- c('id', 'miro_tv', 'motivo_no_mira_tv', 'acostumbro_mirar_tv', 'tipo_tv_a', 'tipo_tv_b', 'frec_tv_aire', 'frec_tv_cable', 'frec_tv_por_computadora', 'frec_tv_por_celular', 'frec_tv_por_tablet', 'frec_tv_por_television', 'frec_mientras_tv_redes_sociales', 'frec_mira_tv_en_directo', 'tv_mira_tv_en_diferido', 'cuantos_televisores', 'cuantos_smart_tv', 'miro_peliculas_series', 'motivo_no_peliculas_series', 'otro_motivo_no_peliculas_series', 'acostumbro_mirar_peliculas_series', 'frec_animacion', 'frec_videos_musicales', 'frec_documentales', 'frec_humoristicos', 'frec_comedias', 'frec_peliculas', 'frec_series_novelas', 'frec_canales_aire', 'frec_canales_cable', 'frec_netflix', 'frec_dvd', 'frec_youtube', 'frec_descargadas', 'gasto_streaming', 'cuantas_peliculas_series_en_dvd', 'gasto_dvd', 'minutos_tv_total', 'horas_tv_total')

# Diarios
# encuesta_diarios_todos_los_campos <- select(encuesta, id, p29, p29_1, p29_1otr, p29_2, p30, p30_bis, p31horas, p31minutos, horas_diario, minutos_diario, p32, p33, p33_bis,p33_1, p33_1_bis, p34, p34_1, p35_1, p35_2, p35_3, p36, minutos_diario_1, minutos_diario_total, horas_diario_total) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

encuesta_diarios <- select(encuesta, id, p29, p29_1, p29_1otr, p29_2, p30, p32, p33, p33_1, p34, p34_1, p35_1, p35_2, p35_3, p36, minutos_diario_total, horas_diario_total) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

colnames(encuesta_diarios) <- c('id', 'leyo_diarios', 'motivo_no_diarios', 'otro_motivo_no_diarios', 'acostumbro_leer_diarios', 'cuantos_diarios_lee', 'frec_diario_papel', 'cuantos_diarios_papel', 'gasto_diario_papel', 'frec_diario_online', 'dispositivo_diario_online', 'frec_compro_diario', 'frec_diario_bar_cafe', 'frec_noticias_redes_sociales', 'papel_o_online', 'minutos_diario_total', 'horas_diario_total')

# General de cultura
encuesta_general <- select(encuesta, id, p1, p1otros) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

colnames(encuesta_general) <- c('id', 'significado_cultura', 'otro_significado_cultura')

# Internet
# encuesta_internet_todos_los_campos <- select(encuesta, id, p72, p72_1, p72_1otr, p72_2, p73, p74, p74_1, p74_2, p74_3, p74_4, p74_4_bis, p75_1, p75_2, p75_3, p75_4, p76horas, p76minutos, horas_internet, minutos_internet, p77_1, p77_2, p77_3, p77_4, p77_5, p77_6, p77_7, p77_8, p77_9, p77_10, p78_1, p78_2, p78_3, p78_4, p78_5,p78_1_1, p78_1_2, p78_1_3, p78_1_4, p78_1_5, p78_2b, p78_3b_1, p78_3b, p79_1, p79_2, p79_3, p79_4, p79_5, p79_6, p79_7, p80horas, p80minutos, horas_redes,minutos_redes, p81, p81_1a, p81_1b, p81_1c, p81_1d, p81_1e, p81_1f, p81_1g, p81_1h, p81_1i, p81_1j, p81_1k, p81_1l, p82, p83, p84, p85, p85_1, p85_2, p85_3,p85_3_bis, p86, minutos_internet_1, minutos_internet_total, horas_internet_total, minutos_redes_1, minutos_redes_total, horas_redes_total) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

encuesta_internet <- select(encuesta, id, p72, p72_1, p72_1otr, p72_2, p73, p74, p74_1, p74_2, p74_3, p74_4, p75_1, p75_2, p75_3, p75_4, p77_1, p77_2, p77_3, p77_4, p77_5, p77_6, p77_7, p77_8, p77_9, p77_10, p78_1, p78_2, p78_3, p78_4, p78_5,p78_1_1, p78_1_2, p78_1_3, p78_1_4, p78_1_5, p78_3b_1, p78_3b, p79_1, p79_2, p79_3, p79_4, p79_5, p79_6, p79_7, p81, p81_1a, p81_1b, p81_1c, p81_1d, p81_1e, p81_1f, p81_1g, p81_1h, p81_1i, p81_1j, p81_1k, p81_1l, p82, p83, p84, p85, p85_1, p85_2, p85_3, p86, minutos_internet_total, horas_internet_total, minutos_redes_total, horas_redes_total) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

colnames(encuesta_internet) <- c('id', 'usa_internet', 'motivo_no_internet', 'otro_motivo_no_internet', 'acostumbro_usar_internet', 'uso_aplicaciones', 'conexion_internet_hogar', 'tv_paga', 'gasto_tv_paga', 'pack_internet', 'gasto_internet', 'frec_internet_computadora', 'frec_internet_celular', 'frec_internet_tablet', 'frec_internet_tv', 'frec_mails', 'frec_noticias', 'frec_estudio', 'frec_compras', 'frec_ver_youtubers', 'frec_leer_criticas_peliculas', 'frec_leer_criticas_libros', 'frec_buscar_act_cultural', 'frec_tutoriales_musica', 'frec_tramites', 'tiene_facebook', 'tiene_instagram', 'tiene_twitter', 'tiene_snapchat', 'tiene_linkedin', 'frec_facebook', 'frec_instagram', 'frec_twitter', 'frec_snapchat', 'frec_linkedin', 'otra_red_social_a', 'otra_red_social_b', 'frec_escribe_criticas', 'frec_comparte_musica', 'frec_sigue_artistas', 'frec_crea_contenido', 'frec_transmite_vivo', 'frec_comparte_fotos', 'frec_sigue_org_publico', 'tipo_uso_internet', 'contenido_creado_a', 'contenido_creado_b', 'contenido_creado_c', 'contenido_creado_d', 'contenido_creado_e', 'contenido_creado_f', 'contenido_creado_g', 'contenido_creado_h', 'contenido_creado_i', 'contenido_creado_j', 'contenido_creado_k', 'contenido_creado_l', 'cuantas_computadoras', 'cuantas_tablets', 'cuantos_telefonos_fijos', 'cuantos_celulares_activos', 'internet_en_celulares', 'celular_con_4g', 'abono_celular', 'gasto_dispositivos', 'minutos_internet_total', 'horas_internet_total', 'minutos_redes_total', 'horas_redes_total')

# Música
# encuesta_musica_todos_los_campos <- select(encuesta, id, p10, p10_1, p10_1otr, p10_2, p11, p12horas, p12minutos, horas_musica, minutos_musica, p13_1, p13_2, p13_3, p13_4,p13_5, p13_6, p13_7, p13_8, p13_9, p14_1, p14_2, p14_3, p14_4, p14_5, p14_6, p14_7, p14_8, p14_9, p14_10, p14_11, p14_12, p14_13, p14_14, p15, p16, p17_1,p17_2, p18a, p18b, p18c, p18d, p18e, p18f, p18g, p18otros, p19, p20, p21, p22, minutos_musica_1, minutos_musica_total, horas_musica_total) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

encuesta_musica <- select(encuesta, id, p10, p10_1, p10_1otr, p10_2, p11, p13_1, p13_2, p13_3, p13_4,p13_5, p13_6, p13_7, p13_8, p13_9, p14_1, p14_2, p14_3, p14_4, p14_5, p14_6, p14_7, p14_8, p14_9, p14_10, p14_11, p14_12, p14_13, p14_14, p15, p16, p17_1,p17_2, p18a, p18b, p18c, p18d, p18e, p18f, p18g, p18otros, p19, p20, p21, p22, minutos_musica_total, horas_musica_total) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

colnames(encuesta_musica) <- c('id', 'escucho_musica', 'motivo_no_escucha', 'otro_motivo_no_escucha', 'acostumbro_escuchar_musica', 'frec_musica', 'frec_cds', 'frec_auto', 'frec_computadora', 'frec_celular', 'frec_tablet', 'frec_mp3', 'frec_casette', 'frec_tocadisco', 'frec_tv', 'frec_folclore', 'frec_rock_extranjero', 'frec_rock_nacional', 'frec_clasica', 'frec_jazz', 'frec_cumbia', 'frec_reggaeton', 'frec_salsa', 'frec_melodica', 'frec_pop', 'frec_reggae', 'frec_electronica', 'frec_tango', 'frec_latinoamericana', 'proporcion_nacionales_de10', 'musica_desde_internet', 'musica_online', 'musica_descargas', 'aplicacion_a', 'aplicacion_b', 'aplicacion_c', 'aplicacion_d', 'aplicacion_e', 'aplicacion_f', 'aplicacion_g', 'aplicacion_otros', 'gastos_suscripciones', 'cuantos_cds', 'gastos_cds', 'cuantos_dispositivos_mp3', 'minutos_musica_total', 'horas_musica_total')

# Recitales
# encuesta_recitales_todos_los_campos <- select(encuesta, id, p23, p23_1, p23_1otr, p23_2, p24, p25, p25_bis, p25_1, p25_1_bis, p26, p26_bis, p27, p27_1, p28) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

encuesta_recitales <- select(encuesta, id, p23, p23_1, p23_1otr, p23_2, p24, p25, p25_1, p26, p27, p27_1, p28) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

colnames(encuesta_recitales) <- c('id', 'concurrio_recitales', 'motivo_no_concurre', 'otro_motivo_no_concurre', 'acostumbro_acudir_recitales', 'frecuencia_recitales', 'cantidad_recitales', 'cantidad_nacionales', 'gasto_recitales', 'instrumentos_en_hogar', 'cuantos_instrumentos', 'practica_musica')

# Revistas
# encuesta_revistas_todos_los_campos <- select(encuesta, id, p37, p37_1, p38, p39, p39_bis, p39_1, p40, p40_bis, p41) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

encuesta_revistas <- select(encuesta, id, p37, p37_1, p38, p39, p39_1, p40, p41) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

colnames(encuesta_revistas) <- c('id', 'leyo_revistas', 'acostumbro_leer_revistas', 'frec_revistas', 'cuantas_revistas_3meses', 'revistas_importadas_3meses', 'gasto_revistas_3meses', 'frec_revistas_online')

# Videojuegos
# encuesta_videojuegos_todos_los_campos <- select(encuesta, id, p87, p88, p89horas, p89minutos, horas_videojuegos, minutos_videojuegos, p90_1, p90_2, p90_3, p90_4, p91, p91_bis, minutos_videojuegos_1, minutos_videojuegos_total, horas_videojuegos_total) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

encuesta_videojuegos <- select(encuesta, id, p87, p88, p90_1, p90_2, p90_3, p90_4, p91, minutos_videojuegos_total, horas_videojuegos_total) %>% mutate_all(na_if, 'NS/NC') %>% mutate_all(na_if, '')

colnames(encuesta_videojuegos) <- c('id', 'jugo_videojuegos', 'frecuencia', 'uso_computadora', 'uso_celular', 'uso_tablet', 'uso_consola', 'gasto_videjuegos', 'minutos_videojuegos_total', 'horas_videojuegos_total')




# Exploracion
# jugó videojuegos?
encuesta_datos %>% 
  inner_join(encuesta_videojuegos, by = 'id') %>% 
  ggplot(mapping = aes(y = rango_etario, fill=jugo_videojuegos)) +
  geom_bar(position = 'fill')

# miró televisión
encuesta_datos %>% 
  inner_join(encuesta_audiovisual, by = 'id') %>% 
  ggplot(mapping = aes(y = rango_etario, fill=miro_tv)) +
  geom_bar(position = 'fill')

# Opinó en redes sociales sobre lo que miraba en tv
encuesta_datos %>% 
  inner_join(encuesta_audiovisual, by = 'id') %>% 
  filter(miro_tv == 'SI') %>% 
  ggplot(mapping = aes(y = rango_etario, fill=frec_mientras_tv_redes_sociales)) +
  geom_bar(position = 'fill')

# Miró peliculas o series
encuesta_datos %>% 
  inner_join(encuesta_audiovisual, by = 'id') %>% 
  ggplot(mapping = aes(y = rango_etario, fill=miro_peliculas_series)) +
  geom_bar(position = 'fill')

# Frecuencia de mirar películas
encuesta_datos %>% 
  inner_join(encuesta_audiovisual, by = 'id') %>% 
  filter(miro_tv == 'SI' & !is.na(frec_peliculas)) %>% 
  ggplot(mapping = aes(y = rango_etario, fill=frec_peliculas)) +
  geom_bar(position = 'fill')

# Significado cultura
encuesta_datos %>% 
  inner_join(encuesta_general, by = 'id') %>%
  filter(!is.na(significado_cultura)) %>%
  ggplot(mapping = aes(fill = rango_etario, y=significado_cultura)) +
  geom_bar(position = 'fill')

# Fue a recitales
encuesta_datos %>% 
  inner_join(encuesta_recitales, by = 'id') %>%
  ggplot(mapping = aes(y = rango_etario, fill=concurrio_recitales)) +
  geom_bar(position = 'fill')

# Escucho radio
encuesta_datos %>% 
  inner_join(encuesta_radio, by = 'id') %>% 
  ggplot(mapping = aes(y = rango_etario, fill=escucha_radio)) +
  geom_bar(position = 'fill')

# Usó internet
encuesta_datos %>% 
  inner_join(encuesta_internet, by = 'id') %>% 
  ggplot(mapping = aes(y = rango_etario, fill=usa_internet)) +
  geom_bar(position = 'fill')

# Frecuencia de ver youtubers
encuesta_datos %>% 
  inner_join(encuesta_internet, by = 'id') %>% 
  filter(usa_internet == 'SI') %>% 
  ggplot(mapping = aes(y = rango_etario, fill=frec_ver_youtubers)) +
  geom_bar(position = 'fill')

# Frecuencia de ver escuchar musica desde internet
encuesta_datos %>% 
  inner_join(encuesta_musica, by = 'id') %>% 
  filter(escucho_musica == 'SI') %>% 
  ggplot(mapping = aes(y = rango_etario, fill=musica_desde_internet)) +
  geom_bar(position = 'fill')

# fue a bailar
encuesta_datos %>% 
  inner_join(encuesta_baile, by = 'id') %>% 
  ggplot(mapping = aes(y = rango_etario, fill=fue_a_bailar)) +
  geom_bar(position = 'fill')


o# Suma de redes sociales en grupo etario
encuesta_datos %>% 
  inner_join(encuesta_internet, by = 'id') %>% 
  group_by(rango_etario) %>% 
  summarise(n_encuestas = n(), 
            n_facebook = sum(tiene_facebook == 'SI', na.rm = T),
            n_instagram = sum(tiene_instagram == 'SI', na.rm = T),
            n_twitter = sum(tiene_twitter == 'SI', na.rm = T),
            n_snapchat = sum(tiene_snapchat == 'SI', na.rm = T),
            n_linkedin = sum(tiene_linkedin == 'SI', na.rm = T)) %>% 
  view()

# Otras redes sociales
unique(encuesta_internet$otra_red_social_a)
unique(encuesta_internet$otra_red_social_b)

# Minutos totales de internet
encuesta_datos %>% 
  inner_join(encuesta_internet, by = 'id') %>% 
  summarise(minutos_internet = sum(minutos_internet_total, na.rm = T))

# cantidad de encuestas x grupo etario
n_grupos <- encuesta_datos %>% 
  group_by(rango_etario) %>% 
  summarise(n_grupo = n())

# Minutos totales de internet x grupo etario
n_minutos_grupo <- encuesta_datos %>% 
  inner_join(encuesta_internet, by = 'id') %>% 
  group_by(rango_etario) %>% 
  summarise(minutos_internet = sum(minutos_internet_total, na.rm = T))

n_minutos_grupo[2] / n_grupos[2]

# gráfico de edades
ggplot(data = encuesta, mapping = aes(x = edad)) +
  geom_density() +
  labs(title = 'Distribución de edades de la población encuestada', x = 'Edad', y = 'Densidad') +
  theme_bw()

# gráfico de sexos encuestados
ggplot(data = encuesta, mapping = aes(x = sexo)) +
  geom_bar() +
  labs(title = 'Cantidad de varones y mujeres encuestadxs', x = 'Sexo', y = 'Cantidad de encuestadxs') +
  theme_bw()

# gráfico de región de lx encuestadx
ggplot(data = encuesta, mapping = aes(x = region)) +
  geom_bar() +
  labs(title = 'Encuestadxs según la región donde viven', x = 'Región', y = 'Cantidad de encuestadxs') +
  theme_bw()

# region x grupo etario
ggplot(data = encuesta_datos, mapping = aes(x = region, fill = rango_etario)) + geom_bar(position = 'dodge')


# Convertir aplicaciones elegidas a true/ (false o NA) en columnas
encuesta_musica %>% 
  select(id, aplicacion_a, aplicacion_b, aplicacion_c, aplicacion_d, aplicacion_e, aplicacion_f, aplicacion_g, aplicacion_otros) %>% 
  mutate(usa_spotify = (aplicacion_a == 'SPOTIFY' | aplicacion_b == 'SPOTIFY' | aplicacion_c == 'SPOTIFY' | aplicacion_d == 'SPOTIFY' | aplicacion_e == 'SPOTIFY' | aplicacion_f == 'SPOTIFY' | aplicacion_g == 'SPOTIFY')) %>% 
  mutate(usa_google_play = (aplicacion_a == 'GOOGLE PLAY' | aplicacion_b == 'GOOGLE PLAY' | aplicacion_c == 'GOOGLE PLAY' | aplicacion_d == 'GOOGLE PLAY' | aplicacion_e == 'GOOGLE PLAY' | aplicacion_f == 'GOOGLE PLAY' | aplicacion_g == 'GOOGLE PLAY')) %>% 
  mutate(usa_youtube = (aplicacion_a == 'YOUTUBE' | aplicacion_b == 'YOUTUBE' | aplicacion_c == 'YOUTUBE' | aplicacion_d == 'YOUTUBE' | aplicacion_e == 'YOUTUBE' | aplicacion_f == 'YOUTUBE' | aplicacion_g == 'YOUTUBE')) %>% 
  mutate(usa_napster = (aplicacion_a == 'NAPSTER' | aplicacion_b == 'NAPSTER' | aplicacion_c == 'NAPSTER' | aplicacion_d == 'NAPSTER' | aplicacion_e == 'NAPSTER' | aplicacion_f == 'NAPSTER' | aplicacion_g == 'NAPSTER')) %>% 
  mutate(usa_deezer = (aplicacion_a == 'DEEZER' | aplicacion_b == 'DEEZER' | aplicacion_c == 'DEEZER' | aplicacion_d == 'DEEZER' | aplicacion_e == 'DEEZER' | aplicacion_f == 'DEEZER' | aplicacion_g == 'DEEZER')) %>% 
  mutate(usa_torrent = (aplicacion_a == 'TORRENT' | aplicacion_b == 'TORRENT' | aplicacion_c == 'TORRENT' | aplicacion_d == 'TORRENT' | aplicacion_e == 'TORRENT' | aplicacion_f == 'TORRENT' | aplicacion_g == 'TORRENT')) %>% 
  mutate(usa_apple_music = (aplicacion_a == 'APPLE MUSIC' | aplicacion_b == 'APPLE MUSIC' | aplicacion_c == 'APPLE MUSIC' | aplicacion_d == 'APPLE MUSIC' | aplicacion_e == 'APPLE MUSIC' | aplicacion_f == 'APPLE MUSIC' | aplicacion_g == 'APPLE MUSIC')) %>% 
  mutate(usa_cienradios = (aplicacion_a == 'CIENRADIOS' | aplicacion_b == 'CIENRADIOS' | aplicacion_c == 'CIENRADIOS' | aplicacion_d == 'CIENRADIOS' | aplicacion_e == 'CIENRADIOS' | aplicacion_f == 'CIENRADIOS' | aplicacion_g == 'CIENRADIOS')) %>% 
  mutate(usa_claro_musica = (aplicacion_a == 'CLARO MÚSICA' | aplicacion_b == 'CLARO MÚSICA' | aplicacion_c == 'CLARO MÚSICA' | aplicacion_d == 'CLARO MÚSICA' | aplicacion_e == 'CLARO MÚSICA' | aplicacion_f == 'CLARO MÚSICA' | aplicacion_g == 'CLARO MÚSICA')) %>% 
  mutate(usa_movistar_musica = (aplicacion_a == 'MOVISTAR MÚSICA' | aplicacion_b == 'MOVISTAR MÚSICA' | aplicacion_c == 'MOVISTAR MÚSICA' | aplicacion_d == 'MOVISTAR MÚSICA' | aplicacion_e == 'MOVISTAR MÚSICA' | aplicacion_f == 'MOVISTAR MÚSICA' | aplicacion_g == 'MOVISTAR MÚSICA')) %>% 
  mutate(usa_personal_play_musica = (aplicacion_a == 'PERSONAL PLAY MÚSICA' | aplicacion_b == 'PERSONAL PLAY MÚSICA' | aplicacion_c == 'PERSONAL PLAY MÚSICA' | aplicacion_d == 'PERSONAL PLAY MÚSICA' | aplicacion_e == 'PERSONAL PLAY MÚSICA' | aplicacion_f == 'PERSONAL PLAY MÚSICA' | aplicacion_g == 'PERSONAL PLAY MÚSICA')) %>% 
  mutate(usa_emule = (aplicacion_a == 'E-MULE' | aplicacion_b == 'E-MULE' | aplicacion_c == 'E-MULE' | aplicacion_d == 'E-MULE' | aplicacion_e == 'E-MULE' | aplicacion_f == 'E-MULE' | aplicacion_g == 'E-MULE')) %>% 
  mutate(usa_ares = (aplicacion_a == 'ARES' | aplicacion_b == 'ARES' | aplicacion_c == 'ARES' | aplicacion_d == 'ARES' | aplicacion_e == 'ARES' | aplicacion_f == 'ARES' | aplicacion_g == 'ARES')) %>% 
  mutate(usa_taringa = (aplicacion_a == 'TARINGA' | aplicacion_b == 'TARINGA' | aplicacion_c == 'TARINGA' | aplicacion_d == 'TARINGA' | aplicacion_e == 'TARINGA' | aplicacion_f == 'TARINGA' | aplicacion_g == 'TARINGA')) %>% 
  mutate(usa_groove_music_pass = (aplicacion_a == 'GROOVE MUSIC PASS' | aplicacion_b == 'GROOVE MUSIC PASS' | aplicacion_c == 'GROOVE MUSIC PASS' | aplicacion_d == 'GROOVE MUSIC PASS' | aplicacion_e == 'GROOVE MUSIC PASS' | aplicacion_f == 'GROOVE MUSIC PASS' | aplicacion_g == 'GROOVE MUSIC PASS')) %>%
  mutate(usa_grooveshark = (aplicacion_a == 'GROOVE SHARK' | aplicacion_b == 'GROOVE SHARK' | aplicacion_c == 'GROOVE SHARK' | aplicacion_d == 'GROOVE SHARK' | aplicacion_e == 'GROOVE SHARK' | aplicacion_f == 'GROOVE SHARK' | aplicacion_g == 'GROOVE SHARK')) %>% 
  mutate(usa_soundcloud = (aplicacion_a == 'SOUNDCLOUD' | aplicacion_b == 'SOUNDCLOUD' | aplicacion_c == 'SOUNDCLOUD' | aplicacion_d == 'SOUNDCLOUD' | aplicacion_e == 'SOUNDCLOUD' | aplicacion_f == 'SOUNDCLOUD' | aplicacion_g == 'SOUNDCLOUD')) %>% 
  mutate(usa_itunes = (aplicacion_a == 'I-TUNES' | aplicacion_b == 'I-TUNES' | aplicacion_c == 'I-TUNES' | aplicacion_d == 'I-TUNES' | aplicacion_e == 'I-TUNES' | aplicacion_f == 'I-TUNES' | aplicacion_g == 'I-TUNES')) %>% 
  view()

