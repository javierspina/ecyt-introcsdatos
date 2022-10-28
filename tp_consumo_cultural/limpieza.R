library(tidyverse)

# leer dataset
encuesta <- read.csv('/Users/javierspina/Downloads/TP Consumo Cultural/encc_2017.csv')

# limpieza de datos. Las filas 1950 y 2740 tienen sus datos mal ingresados.
encuesta <- encuesta[-c(1950, 2740),]

# adecuación de datos generales
encuesta$edad <- as.integer(encuesta$edad)
encuesta$id <- as.integer(encuesta$id)
encuesta$pondera_dem <- as.integer(encuesta$pondera_dem)
encuesta$sexo <- as.factor(encuesta$sexo)
encuesta$region <- as.factor(encuesta$region)
encuesta$fecha <- as.Date(encuesta$fecha, format = '%d/%m/%Y')

# Seleccionar y Transformar columnas

encuesta_final <- select(encuesta, id, pondera_dem, p2, p2_1, p2_1otro, p2_2, p3, p4, p5, p7_1, p7_2, p7_3, p7_4, p7_5, p8a, p8b, p8c, p8d, p8e, p8f, p8g, p8otros, p9, minutos_radio_total, horas_radio_total, p10, p10_1, p10_1otr, p10_2, p11, p13_1, p13_2, p13_3, p13_4,p13_5, p13_6, p13_7, p13_8, p13_9, p14_1, p14_2, p14_3, p14_4, p14_5, p14_6, p14_7, p14_8, p14_9, p14_10, p14_11, p14_12, p14_13, p14_14, p15, p16, p17_1,p17_2, p18a, p18b, p18c, p18d, p18e, p18f, p18g, p18otros, p19, p20, p21, p22, minutos_musica_total, horas_musica_total, p23, p23_1, p23_1otr, p23_2, p24, p25, p25_1, p26, p27, p27_1, p28, p29, p29_1, p29_1otr, p29_2, p30, p32, p33, p33_1, p34, p34_1, p35_1, p35_2, p35_3, p36, minutos_diario_total, horas_diario_total, p37, p37_1, p38, p39, p39_1, p40, p41, p42, p42_1, p42_1otr, p42_2, p43, p43_1, p44, p44otros, p45, p45_1, p46, p47,p47_1a, p47_1b, p47_1c, p47_1d, p47_2, p48_1, p48_2, p48_3, p48_4, p48_5, p48_6, p48_7, p48_8, p48_9, p48_10, p48_11, p48_12, p48_13, p48_14, p48_15, p48_16, p49, p49_1, p49_2, p51a, p51b, p52, p53, p54_1, p54_2, p54_3, p54_4, p55_1, p55_2, p55_3, p56, p56_1, p57, p57_1, p57_1otr, p57_2, p58_1, p58_2, p58_3, p58_4, p58_5, p58_6, p58_7, p59_1, p59_2, p59_3, p59_4, p59_5, p59_6, p60, p61, p62, minutos_tv_total, horas_tv_total)

colnames(encuesta_final) <- c('id', 'pondera_dem', 'escucha_radio', 'motivo_no_radio', 'otro_motivo_no_radio', 'acostumbro_escuchar_radio','radio_online', 'frec_escucho_radio', 'am_o_fm', 'radio_estero', 'radio_auto', 'radio_computadora', 'radio_celular', 'radio_tablet', 'tipo_programa_a', 'tipo_programa_b', 'tipo_programa_c', 'tipo_programa_d', 'tipo_programa_e', 'tipo_programa_f', 'tipo_programa_g', 'tipo_programa_otros', 'cuantos_equipos', 'minutos_radio_total', 'horas_radio_total', 'escucho_musica', 'motivo_no_escucha', 'otro_motivo_no_escucha', 'acostumbro_escuchar_musica', 'frec_musica', 'frec_cds', 'frec_auto', 'frec_computadora', 'frec_celular', 'frec_tablet', 'frec_mp3', 'frec_casette', 'frec_tocadisco', 'frec_tv', 'frec_folclore', 'frec_rock_extranjero', 'frec_rock_nacional', 'frec_clasica', 'frec_jazz', 'frec_cumbia', 'frec_reggaeton', 'frec_salsa', 'frec_melodica', 'frec_pop', 'frec_reggae', 'frec_electronica', 'frec_tango', 'frec_latinoamericana', 'proporcion_nacionales_de10', 'musica_desde_internet', 'musica_online', 'musica_descargas', 'aplicacion_a', 'aplicacion_b', 'aplicacion_c', 'aplicacion_d', 'aplicacion_e', 'aplicacion_f', 'aplicacion_g', 'aplicacion_otros', 'gastos_suscripciones', 'cuantos_cds', 'gastos_cds', 'cuantos_dispositivos_mp3', 'minutos_musica_total', 'horas_musica_total', 'concurrio_recitales', 'motivo_no_concurre', 'otro_motivo_no_concurre', 'acostumbro_acudir_recitales', 'frecuencia_recitales', 'cantidad_recitales', 'cantidad_nacionales', 'gasto_recitales', 'instrumentos_en_hogar', 'cuantos_instrumentos', 'practica_musica', 'leyo_diarios', 'motivo_no_diarios', 'otro_motivo_no_diarios', 'acostumbro_leer_diarios', 'cuantos_diarios_lee', 'frec_diario_papel', 'cuantos_diarios_papel', 'gasto_diario_papel', 'frec_diario_online', 'dispositivo_diario_online', 'frec_compro_diario', 'frec_diario_bar_cafe', 'frec_noticias_redes_sociales', 'papel_o_online', 'minutos_diario_total', 'horas_diario_total', 'leyo_revistas', 'acostumbro_leer_revistas', 'frec_revistas', 'cuantas_revistas_3meses', 'revistas_importadas_3meses', 'gasto_revistas_3meses', 'frec_revistas_online', 'leyo_libros', 'razon_no_lee', 'otra_razon_no_lee',  'acostumbro_leer', 'cuantos_libros', 'libros_autorxs_arg', 'razon_ultima_lectura', 'otra_razon_ultima_lectura', 'cuantos_libros_compro', 'cuanto_gasto_libros', 'frec_libros_papel', 'frec_libros_pantalla', 'frec_leer_dispositivo_a', 'frec_leer_dispositivo_b', 'frec_leer_dispositivo_c', 'frec_leer_dispositivo_d', 'pago_lectura_dispositivos', 'frec_cuentos', 'frec_novelas', 'frec_poesia', 'frec_ensayos', 'frec_escolares', 'frec_biografias', 'frec_teatro', 'frec_ciencia', 'frec_comics', 'frec_humor', 'frec_autoayuda', 'frec_historia', 'frec_politica', 'frec_salud', 'frec_divulgacion', 'frec_otros', 'miro_tv', 'motivo_no_mira_tv', 'acostumbro_mirar_tv', 'tipo_tv_a', 'tipo_tv_b', 'frec_tv_aire', 'frec_tv_cable', 'frec_tv_por_computadora', 'frec_tv_por_celular', 'frec_tv_por_tablet', 'frec_tv_por_television', 'frec_mientras_tv_redes_sociales', 'frec_mira_tv_en_directo', 'tv_mira_tv_en_diferido', 'cuantos_televisores', 'cuantos_smart_tv', 'miro_peliculas_series', 'motivo_no_peliculas_series', 'otro_motivo_no_peliculas_series', 'acostumbro_mirar_peliculas_series', 'frec_tv_animacion', 'frec_tv_videos_musicales', 'frec_tv_documentales', 'frec_tv_humoristicos', 'frec_tv_comedias', 'frec_tv_peliculas', 'frec_tv_series_novelas', 'frec_canales_aire', 'frec_canales_cable', 'frec_netflix', 'frec_dvd', 'frec_youtube', 'frec_descargadas', 'gasto_streaming', 'cuantas_peliculas_series_en_dvd', 'gasto_dvd', 'minutos_tv_total', 'horas_tv_total')


encuesta_final2 <- select(encuesta, id, p63, p63_1, p63_1otr, p63_2, p64, p65, p65_1, p66, p66otros, p67_1, p67_2, p67_3, p67_4, p67_5, p67_6, p67_7, p67_8, p67_9, p67_10, p67_11, p68, p69, p70, p70_1, p71, p72, p72_1, p72_1otr, p72_2, p73, p74, p74_1, p74_2, p74_3, p74_4, p75_1, p75_2, p75_3, p75_4, p77_1, p77_2, p77_3, p77_4, p77_5, p77_6, p77_7, p77_8, p77_9, p77_10, p78_1, p78_2, p78_3, p78_4, p78_5,p78_1_1, p78_1_2, p78_1_3, p78_1_4, p78_1_5, p78_3b_1, p78_3b, p79_1, p79_2, p79_3, p79_4, p79_5, p79_6, p79_7, p81, p81_1a, p81_1b, p81_1c, p81_1d, p81_1e, p81_1f, p81_1g, p81_1h, p81_1i, p81_1j, p81_1k, p81_1l, p82, p83, p84, p85, p85_1, p85_2, p85_3, p86, minutos_internet_total, horas_internet_total, minutos_redes_total, horas_redes_total, p87, p88, p90_1, p90_2, p90_3, p90_4, p91, minutos_videojuegos_total, horas_videojuegos_total)

colnames(encuesta_final2) <- c('id', 'concurrio_cine', 'motivo_no_cine', 'otro_motivo_no_cine', 'acostumbro_ir_cine', 'frec_cine', 'cuantas_veces_cine', 'cuantas_peliculas_arg', 'razon_eleccion_pelicula', 'otra_razon_eleccion_pelicula', 'frec_cine_accion', 'frec_cine_aventura', 'frec_cine_scifi', 'frec_cine_suspenso', 'frec_cine_terror', 'frec_cine_drama', 'frec_cine_comedia', 'frec_cine_romantico', 'frec_cine_documental', 'frec_cine_infantiles', 'frec_cine_animacion', 'concurrio_tratro', 'frec_teatro', 'cuantas_veces_teatro', 'obras_artistas_arg', 'gasto_teatro', 'usa_internet', 'motivo_no_internet', 'otro_motivo_no_internet', 'acostumbro_usar_internet', 'uso_aplicaciones', 'conexion_internet_hogar', 'tv_paga', 'gasto_tv_paga', 'pack_internet', 'gasto_internet', 'frec_internet_computadora', 'frec_internet_celular', 'frec_internet_tablet', 'frec_internet_tv', 'frec_mails', 'frec_noticias', 'frec_estudio', 'frec_compras', 'frec_ver_youtubers', 'frec_leer_criticas_peliculas', 'frec_leer_criticas_libros', 'frec_buscar_act_cultural', 'frec_tutoriales_musica', 'frec_tramites', 'tiene_facebook', 'tiene_instagram', 'tiene_twitter', 'tiene_snapchat', 'tiene_linkedin', 'frec_facebook', 'frec_instagram', 'frec_twitter', 'frec_snapchat', 'frec_linkedin', 'otra_red_social_a', 'otra_red_social_b', 'frec_escribe_criticas', 'frec_comparte_musica', 'frec_sigue_artistas', 'frec_crea_contenido', 'frec_transmite_vivo', 'frec_comparte_fotos', 'frec_sigue_org_publico', 'tipo_uso_internet', 'contenido_creado_a', 'contenido_creado_b', 'contenido_creado_c', 'contenido_creado_d', 'contenido_creado_e', 'contenido_creado_f', 'contenido_creado_g', 'contenido_creado_h', 'contenido_creado_i', 'contenido_creado_j', 'contenido_creado_k', 'contenido_creado_l', 'cuantas_computadoras', 'cuantas_tablets', 'cuantos_telefonos_fijos', 'cuantos_celulares_activos', 'internet_en_celulares', 'celular_con_4g', 'abono_celular', 'gasto_dispositivos', 'minutos_internet_total', 'horas_internet_total', 'minutos_redes_total', 'horas_redes_total', 'jugo_videojuegos', 'frecuencia', 'uso_computadora', 'uso_celular', 'uso_tablet', 'uso_consola', 'gasto_videjuegos', 'minutos_videojuegos_total', 'horas_videojuegos_total')


encuesta_comunidad <- select(encuesta, id, p92_1, p92_2, p92_3, p92_4, p92_5, p92_6, p92_7, p92_8, p92_9, p93_1, p93_2, p93_3, p93_4, p94_1, p94_2, p94_3, p94_4, p94_5, p94_6, p95, p96_1, p96_2, p96_3, p96_4, p96_5, p97)

colnames(encuesta_comunidad) <- c('id', 'participa_club', 'participa_centro_jubilados', 'participa_centro_religioso', 'participa_biblioteca', 'participa_local_politico', 'participa_colectividad_extranjera', 'participa_comunidad_indigenta', 'participa_coop_barrial', 'participa_orga_social', 'es_dirigente_org', 'es_voluntario_org', 'es_animador_org', 'es_participante_org', 'participa_coro', 'participa_murga', 'participa_danza_teatro', 'participa_circo', 'concurre_talleres', 'participa_periodismo_aficionado', 'concurrio_boliches', 'tomo_clases_baile_canto', 'tomo_clases_actuacion', 'tomo_clases_arte', 'tomo_clases_literatura', 'tomo_clases_audiovisual', 'gasto_clases')

encuesta_patrimonio <- select(encuesta, id, p98, p99, p100_1, p100_2, p100_3, p100_4, p100_5, p100_6, p101, p102, p103_1, p103_1_1,p103_2, p103_1_2, p103_3, p103_1_3, p103_4, p103_1_4, p103_5, p103_1_5, p103_6, p103_1_6, p103_7, p103_1_7, p103_8, p103_1_8, p103_9, p103_1_9, p103_10, p103_110,p103_11, p103_111, p103_12, p103_112, p103_13, p103_113, p103_14, p103_114, p103_15, p103_115, p103_16, p103_116, p103_17, p103_117, p103_18, p103_118,p103_19, p103_119, p103_20, p103_120)

colnames(encuesta_patrimonio) <- c('id', 'concurrio_museo', 'cuantas_veces_museo', 'frec_museo_historicos', 'frec_museo_cs_naturales', 'frec_museo_tecnologia', 'frec_museo_artes', 'frec_museo_antropologia_arquelogia', 'frec_museo_tematicos', 'pago_entrada_museo', 'gasto_museo', 'frec_circo', 'gasto_circo', 'frec_feria_gastronomia', 'gasto_feria_gastronomia', 'frec_carnavales', 'gasto_carnavales','frec_penia_musical', 'gasto_penia_musical', 'frec_fiesta_religiosa','gasto_fiesta_religiosa', 'frec_fiesta_regional', 'gasto_fiesta_regional', 'frec_kermes', 'gasto_kermes', 'frec_monumentos','gasto_monumentos', 'frec_arquelogia', 'gasto_arqueologia', 'frec_parque_nacional', 'gasto_parque_nacional', 'frec_muestra_pintura', 'gasto_muestra_pintura', 'frec_muestra_escultura', 'gasto_muestra_escultura', 'frec_muestra_fotografia','gasto_muestra_fotografia', 'frec_archivo_historico', 'gasto_archivo_historico', 'frec_presentacion_danza', 'gasto_presentacion_danza', 'frec_opera', 'gasto_opera', 'frec_concierto_musica_clasica', 'gasto_concierto_musica_clasica', 'frec_feria_artesanal', 'gasto_feria_artesanal', 'frec_centro_cultura', 'gasto_centro_cultural', 'frec_ferias_libro', 'gasto_ferias_libro')

encuesta_demografia <- select(encuesta, id, p104, p104_1, p104_2, p105, p106, p107, p108, p109, p110, p110b, p111, p111b, p112, p113_1, p113_2, p113_3, p113_4, p113_5, p114, p115_1, p115_2, p115_3, p115_4, p115_5, p116, p116b, p117)

colnames(encuesta_demografia) <- c('id', 'cant_convivientes', 'convivientes_menores15', 'convivientes_mayores65', 'cantidad_habitaciones', 'nivel_estudios', 'jefx_hogar', 'nivel_estudios_jefx', 'situacion_jefx', 'ocupacion_jefx', 'cat_ocupacion_jefx', 'cat_ocupacion_jefx2', 'cat_ocupacion_jefx3', 'cobertura_medica_jefx', 'hogar_tiene_internet', 'hogar_tiene_1auto', 'hogar_tiene_mas1auto', 'hogar_hay_tarjeta_credito', 'hogar_hay_celular', 'situacion_vivienda', 'limitacion_convivientes_vision', 'limitacion_convivientes_audicion','limitacion_convivientes_desplazarse',  'limitacion_convivientes_motriz', 'limitacion_convivientes_cognitiva', 'tipo_barrio', 'tipo_barrio2', 'tipo_vivienda')

encuesta_general <- select(encuesta, id, p1, p1otros)

colnames(encuesta_general) <- c('id', 'significado_cultura', 'otro_significado_cultura')

encuesta_datos <- select(encuesta, id, region, sexo, edad)

# Categorizar edades
encuesta_datos <- encuesta_datos %>% mutate(rango_etario = case_when(
  edad <= 17 ~ 'Entre 13 y 17',
  edad <= 22 ~ 'Entre 18 y 22',
  edad <= 27 ~ 'Entre 23 y 27',
  edad <= 32 ~ 'Entre 28 y 32',
  edad <= 37 ~ 'Entre 33 y 37',
  edad <= 42 ~ 'Entre 38 y 42',
  edad <= 47 ~ 'Entre 43 y 47',
  edad <= 52 ~ 'Entre 48 y 52',
  edad <= 57 ~ 'Entre 53 y 57',
  edad <= 62 ~ 'Entre 58 y 62',
  edad <= 67 ~ 'Entre 63 y 67',
  edad <= 72 ~ 'Entre 68 y 72',
  edad <= 77 ~ 'Entre 73 y 77',
  edad <= 82 ~ 'Entre 78 y 82',
  edad <= 87 ~ 'Entre 83 y 87',
  edad > 87 ~ 'Mayor a 88',
  TRUE ~ NA_character_
))

encuesta_finalisima <- encuesta_datos %>% 
  inner_join(encuesta_general, by ='id') %>% 
  inner_join(encuesta_final, by = 'id') %>% 
  inner_join(encuesta_final2, by = 'id') %>% 
  inner_join(encuesta_comunidad, by = 'id') %>% 
  inner_join(encuesta_patrimonio, by = 'id') %>% 
  inner_join(encuesta_demografia, by = 'id')


glimpse(encuesta_finalisima)




encuesta_finalisima$gasto_ferias_libro <- as.integer(encuesta_finalisima$gasto_ferias_libro)
encuesta_finalisima$gasto_centro_cultural <- as.integer(encuesta_finalisima$gasto_centro_cultural)
encuesta_finalisima$gasto_feria_artesanal <- as.integer(encuesta_finalisima$gasto_feria_artesanal)
encuesta_finalisima$gasto_concierto_musica_clasica <- as.integer(encuesta_finalisima$gasto_concierto_musica_clasica)
encuesta_finalisima$gasto_opera <- as.integer(encuesta_finalisima$gasto_opera)
encuesta_finalisima$gasto_presentacion_danza <- as.integer(encuesta_finalisima$gasto_presentacion_danza)
encuesta_finalisima$gasto_archivo_historico <- as.integer(encuesta_finalisima$gasto_archivo_historico)
encuesta_finalisima$gasto_muestra_fotografia <- as.integer(encuesta_finalisima$gasto_muestra_fotografia)
encuesta_finalisima$gasto_muestra_escultura <- as.integer(encuesta_finalisima$gasto_muestra_escultura)
encuesta_finalisima$gasto_muestra_pintura <- as.integer(encuesta_finalisima$gasto_muestra_pintura)
encuesta_finalisima$gasto_parque_nacional <- as.integer(encuesta_finalisima$gasto_parque_nacional)
encuesta_finalisima$gasto_arqueologia <- as.integer(encuesta_finalisima$gasto_arqueologia)
encuesta_finalisima$gasto_monumentos <- as.integer(encuesta_finalisima$gasto_monumentos)
encuesta_finalisima$gasto_kermes <- as.integer(encuesta_finalisima$gasto_kermes)
encuesta_finalisima$gasto_fiesta_regional <- as.integer(encuesta_finalisima$gasto_fiesta_regional)
encuesta_finalisima$gasto_fiesta_religiosa <- as.integer(encuesta_finalisima$gasto_fiesta_religiosa)
encuesta_finalisima$gasto_penia_musical <- as.integer(encuesta_finalisima$gasto_penia_musical)
encuesta_finalisima$gasto_carnavales <- as.integer(encuesta_finalisima$gasto_carnavales)
encuesta_finalisima$gasto_feria_gastronomia <- as.integer(encuesta_finalisima$gasto_feria_gastronomia)
encuesta_finalisima$gasto_circo <- as.integer(encuesta_finalisima$gasto_circo)
encuesta_finalisima$gasto_museo <- as.integer(encuesta_finalisima$gasto_museo)

encuesta_finalisima$gasto_clases <- as.integer(encuesta_finalisima$gasto_clases)
encuesta_finalisima$cuantas_veces_museo <- as.integer(encuesta_finalisima$cuantas_veces_museo)
encuesta_finalisima$gasto_dispositivos <- as.integer(encuesta_finalisima$gasto_dispositivos)
encuesta_finalisima$abono_celular <- as.integer(encuesta_finalisima$abono_celular)


encuesta_finalisima$gastos_suscripciones <- as.integer(encuesta_finalisima$gastos_suscripciones)
encuesta_finalisima$cuantos_cds <- as.integer(encuesta_finalisima$cuantos_cds)
encuesta_finalisima$gastos_cds <- as.integer(encuesta_finalisima$gastos_cds)
encuesta_finalisima$cuantos_dispositivos_mp3 <- as.integer(encuesta_finalisima$cuantos_dispositivos_mp3)
encuesta_finalisima$cantidad_recitales <- as.integer(encuesta_finalisima$cantidad_recitales)
encuesta_finalisima$cantidad_nacionales <- as.integer(encuesta_finalisima$cantidad_nacionales)
encuesta_finalisima$gasto_recitales <- as.integer(encuesta_finalisima$gasto_recitales)
encuesta_finalisima$cuantos_instrumentos <- as.integer(encuesta_finalisima$cuantos_instrumentos)
encuesta_finalisima$cuantos_diarios_lee <- as.integer(encuesta_finalisima$cuantos_diarios_lee)
encuesta_finalisima$cuantos_diarios_papel <- as.integer(encuesta_finalisima$cuantos_diarios_papel)
encuesta_finalisima$gasto_diario_papel <- as.integer(encuesta_finalisima$gasto_diario_papel)
encuesta_finalisima$cuantas_revistas_3meses <- as.integer(encuesta_finalisima$cuantas_revistas_3meses)
encuesta_finalisima$revistas_importadas_3meses <- as.integer(encuesta_finalisima$revistas_importadas_3meses)
encuesta_finalisima$gasto_revistas_3meses <- as.integer(encuesta_finalisima$gasto_revistas_3meses)
encuesta_finalisima$cuantos_libros <- as.integer(encuesta_finalisima$cuantos_libros)
encuesta_finalisima$libros_autorxs_arg <- as.integer(encuesta_finalisima$libros_autorxs_arg)
encuesta_finalisima$cuantos_libros_compro <- as.integer(encuesta_finalisima$cuantos_libros_compro)
encuesta_finalisima$cuanto_gasto_libros <- as.integer(encuesta_finalisima$cuanto_gasto_libros)
encuesta_finalisima$cuantos_televisores <- as.integer(encuesta_finalisima$cuantos_televisores)
encuesta_finalisima$cuantos_smart_tv <- as.integer(encuesta_finalisima$cuantos_smart_tv)
encuesta_finalisima$gasto_streaming <- as.integer(encuesta_finalisima$gasto_streaming)
encuesta_finalisima$cuantas_peliculas_series_en_dvd <- as.integer(encuesta_finalisima$cuantas_peliculas_series_en_dvd)
encuesta_finalisima$gasto_dvd <- as.integer(encuesta_finalisima$gasto_dvd)
encuesta_finalisima$cuantas_veces_cine <- as.integer(encuesta_finalisima$cuantas_veces_cine)
encuesta_finalisima$cuantas_peliculas_arg <- as.integer(encuesta_finalisima$cuantas_peliculas_arg)
encuesta_finalisima$cuantas_veces_teatro <- as.integer(encuesta_finalisima$cuantas_veces_teatro)
encuesta_finalisima$obras_artistas_arg <- as.integer(encuesta_finalisima$obras_artistas_arg)
encuesta_finalisima$gasto_teatro <- as.integer(encuesta_finalisima$gasto_teatro)
encuesta_finalisima$gasto_tv_paga <- as.integer(encuesta_finalisima$gasto_tv_paga)
encuesta_finalisima$gasto_internet <- as.integer(encuesta_finalisima$gasto_internet)
encuesta_finalisima$cuantas_computadoras <- as.integer(encuesta_finalisima$cuantas_computadoras)
encuesta_finalisima$cuantas_tablets <- as.integer(encuesta_finalisima$cuantas_tablets)
encuesta_finalisima$cuantos_celulares_activos <- as.integer(encuesta_finalisima$cuantos_celulares_activos)
encuesta_finalisima$gasto_videjuegos <- as.integer(encuesta_finalisima$gasto_videjuegos)

write.csv(encuesta_finalisima, '/Users/javierspina/Downloads/TP Consumo Cultural/encc_2017_parseado.csv', row.names = FALSE)
