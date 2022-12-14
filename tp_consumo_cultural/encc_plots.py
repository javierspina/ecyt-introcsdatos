import os
import numpy as np
import pandas as pd
import seaborn as sns
from matplotlib import pyplot as plt
from matplotlib.legend_handler import HandlerTuple

import encc_parse

encuesta = encc_parse.apply_mappings(save_to_csv = False)

#%%
'''
Plot Concurrencia a los museos según Nivel Socio-Económico

Genera un gráfico de barras con los porcentajes de asistencia al museo dentro
de cada nivel socioeconómico
'''
asist_museo_nse_x100_fname = os.path.join('slides', 'out', 'asist_museo_nse_x100.png')

# Totales NSE x pondera_dem
encuesta_nse = pd.pivot_table(encuesta,
                                 values='pondera_dem',
                                 index='NSEdenom',
                                 aggfunc=np.sum)

# Totales asistencia a museos x NSE
asist_museo_nse = pd.pivot_table(encuesta,
                                 values='pondera_dem',
                                 index='NSEdenom',
                                 columns='concurre_museo',
                                 aggfunc=np.sum)

# Merge de asistencia a museos x NSE + totales NSE
asist_museo_nse = pd.merge(left = asist_museo_nse,
                           right = encuesta_nse,
                           on = 'NSEdenom')

# Convertir el df a valores porcentuales dentro de cada NSE
asist_museo_nse_x100 = np.round(asist_museo_nse.div(asist_museo_nse.pondera_dem, axis=0)*100, 1)


asist_museo_nse_x100 = asist_museo_nse_x100.rename(columns={'SI': '2017'})
asist_museo_nse_x100['2013'] = [32, 29.4, 19.5, 13, 11, np.nan]

asist_museo_nse_x100 = asist_museo_nse_x100[['2013', '2017']]

asist_museo_nse_x100 = asist_museo_nse_x100.reset_index().melt(id_vars=['NSEdenom'], value_vars=['2013', '2017'], var_name='Año', value_name='asistencia')

asist_museo_nse_x100 = pd.concat([asist_museo_nse_x100.iloc[0:5], asist_museo_nse_x100.iloc[6:11]])


# Ploteo
sns.set(font_scale=2, style='whitegrid')
fig = plt.figure(figsize=(12, 9))
ax = sns.barplot(x=asist_museo_nse_x100.NSEdenom,
                 y=asist_museo_nse_x100.asistencia,
                 hue=asist_museo_nse_x100.Año)    # iloc[:-1] para no graficar NSE marginal

for bar_group, desaturate_value in zip(ax.containers, [0.5, 1]):
    for bar, color in zip(bar_group, plt.cm.Set1.colors):
        bar.set_facecolor(sns.desaturate(color, desaturate_value))

ax.legend(handles=[tuple(bar_group) for bar_group in ax.containers],
          labels=[bar_group.get_label() for bar_group in ax.containers],
          title=ax.legend_.get_title().get_text(),
          handlelength=4, handler_map={tuple: HandlerTuple(ndivide=None, pad=0.1)})
sns.despine()
plt.tight_layout()


for container in ax.containers:
    tmp_hue = asist_museo_nse_x100.loc[asist_museo_nse_x100['Año']==container.get_label()]
    ax.bar_label(container, labels=tmp_hue['asistencia'])
#ax.bar_label(ax.containers[0])    # Agrega labels a las barras
ax.set(xlabel='Nivel Socio-Económico',
       ylabel='Asistencia [% NSE]',
       title='Concurrencia a los museos según Nivel Socio-Económico',
       ylim=(0, 34))
plt.savefig(asist_museo_nse_x100_fname, dpi=100, transparent=True)
#plt.show()

#%%
entradas_proporcional = pd.read_csv(os.path.join('data_src', 'entradas_proporcional.csv'))
modelo_entradas_museos = pd.read_csv(os.path.join('data_src', 'modelo_entradas_por_museos.csv'))

fig, ax = plt.subplots(figsize=(12, 8))
sns.scatterplot(data = entradas_proporcional,
                     x = entradas_proporcional.museos_por_hab,
                     y = entradas_proporcional.entradas_por_hab,
                     hue = entradas_proporcional.NSEdenom,
                     palette = plt.cm.Set1.colors,
                     ax=ax,
                     s=100)
sns.lineplot(data=modelo_entradas_museos,
             x=modelo_entradas_museos.museos_por_hab,
             y=modelo_entradas_museos.pred,
             ax=ax,
             size=False,
             sizes=(3,5),
             hue=modelo_entradas_museos.NSEdenom,
             palette=plt.cm.Set1.colors,
             legend=False)

sns.move_legend(ax, 'upper left', bbox_to_anchor=(1, 1), title='NSE', frameon=True)

ax.set(title='Entradas expedidas según la cantidad de museos',
       xlabel = 'Museos por región cada 100.000 habitantes',
       ylabel = 'Entradas cada 100.000 habitantes')

modelo_entrada_museo_fname = os.path.join('slides', 'out', 'modelo_entrada_museo.png')
plt.tight_layout()

plt.savefig(modelo_entrada_museo_fname, dpi=100, transparent=True)


# %% Histograma de edades

mapper = {'SECUNDARIA INCOMPLETA': 'SECUNDARIA INCOMPLETA',
          'SECUNDARIA COMPLETA': 'SECUNDARIA COMPLETA',
          'UNIVERSITARIO INCOMPLETO': 'SECUNDARIA COMPLETA',
          'TERCIARIO INCOMPLETO': 'SECUNDARIA COMPLETA',
          'TERCIARIO COMPLETO': 'SUPERIOR COMPLETO',
          'PRIMARIA COMPLETA': 'SECUNDARIA INCOMPLETA',
          'PRIMARIA INCOMPLETA': 'PRIMARIA INCOMPLETA',
          'UNIVERSITARIO COMPLETO': 'SUPERIOR COMPLETO',
          'POSGRADO INCOMPLETO O COMPLETO': 'SUPERIOR COMPLETO',
          'SIN ESTUDIOS': 'PRIMARIA INCOMPLETA'}

encuesta = encuesta.replace(to_replace=mapper)

encuesta.to_csv('data_src/encuesta_estudios_simple.csv')
#%%
sns.set(font_scale=2, style="whitegrid")
fig = plt.figure(figsize=(17, 6), dpi=300)

ax = sns.histplot(data=encuesta[encuesta['concurre_museo'] == 'NO'],
                  x='edad',
                  weights='pondera_dem',
                  bins=15,
                  hue='nivel_estudios',
                  kde=True,
                  multiple='dodge')

ax.set(title='No asistencia al museo según edad y nivel de estudios',
       xlabel = 'Edad',
       ylabel = 'Habitantes [Millones]')

sns.move_legend(ax, "upper left", bbox_to_anchor=(0.75, 1))

plt.tight_layout()
plt.savefig('slides/out/dist_no_asistentes.png', dpi=300, transparent=True)

#%%
sns.set(font_scale=2, style="whitegrid")
fig = plt.figure(figsize=(17, 6), dpi=300)

ax = sns.histplot(data=encuesta[encuesta['concurre_museo'] == 'SI'],
                  x='edad',
                  weights='pondera_dem',
                  bins=15,
                  hue='nivel_estudios',
                  kde=True,
                  multiple='dodge')

ax.set(title='Asistencia al museo según edad y nivel de estudios',
       xlabel = 'Edad',
       ylabel = 'Habitantes')

sns.move_legend(ax, "upper left", bbox_to_anchor=(0.75, 1))

plt.tight_layout()
plt.savefig('slides/out/dist_asistentes.png', dpi=300, transparent=True)

# %%

sns.set(font_scale=2, style="whitegrid")
fig = plt.figure(dpi=300, figsize=(12, 8))

ax = sns.histplot(data=encuesta,
                  x='edad',
                  weights='pondera_dem',
                  bins=30,
                  y='nivel_estudios',
                  hue='concurre_museo')

#ax.set(title='Histograma de edades',
#       xlabel = 'Edad',
#       ylabel = 'Cantidad de habitantes')

#plt.legend(title='Asistió a museo', loc='upper right', labels=['No', 'Si'])

#modelo_entrada_museo_fname = os.path.join('slides', 'out', 'histo_edades_concurrencia.png')

#plt.savefig(modelo_entrada_museo_fname, dpi=100, transparent=True)


# %%

encuesta_simple = pd.read_csv('data_src/encuesta_simple.csv')

encuesta_simple = encuesta_simple[encuesta_simple['NSEdenom'] != '6- Marginal']

sns.set(font_scale=2, style="whitegrid")
fig = plt.figure(figsize=(20, 5), dpi=300)

ax = sns.histplot(data=encuesta_simple[encuesta_simple['concurre_museo'] == 'NO'],
                  x='NSEpuntaje',
                  weights='pondera_dem',
                  bins=30,
                  hue='situacion_psh',
                  kde=True,
                  multiple='layer')

plt.axvline(38, 0, 2, color='black')
plt.axvline(52, 0, 2, color='black')
plt.axvline(69, 0, 2, color='black')
plt.axvline(84, 0, 2, color='black')


ax.set(title='No asistencia al museo según NSE y situación laboral',
       xlabel = 'Puntaje NSE',
       ylabel = 'Habitantes [Millones]')

sns.move_legend(ax, "upper left", bbox_to_anchor=(0, 1.05))

plt.tight_layout()
plt.savefig('slides/out/dist_no_asistentes_lab.png', dpi=300, transparent=True)

#%%

encuesta_simple = encuesta_simple[encuesta_simple['NSEdenom'] != '6- Marginal']

sns.set(font_scale=2, style="whitegrid")
fig = plt.figure(figsize=(20, 5), dpi=300)

ax = sns.histplot(data=encuesta_simple[encuesta_simple['concurre_museo'] == 'SI'],
                  x='NSEpuntaje',
                  weights='pondera_dem',
                  bins=30,
                  hue='situacion_psh',
                  kde=True,
                  multiple='layer')

plt.axvline(38, 0, 2, color='black')
plt.axvline(52, 0, 2, color='black')
plt.axvline(69, 0, 2, color='black')
plt.axvline(84, 0, 2, color='black')


ax.set(title='Asistencia al museo según NSE y situación laboral',
       xlabel = 'Puntaje NSE',
       ylabel = 'Habitantes')

sns.move_legend(ax, "upper left", bbox_to_anchor=(0, 1.05))

plt.tight_layout()
plt.savefig('slides/out/dist_asistentes_lab.png', dpi=300, transparent=True)

# %%

edad_escolar = encuesta_simple[encuesta_simple['edad'] < 18][encuesta_simple['nivel_estudios'] == 'SECUNDARIA INCOMPLETA']

sns.set(font_scale=2, style="whitegrid")
fig = plt.figure(figsize=(6, 10), dpi=300)

ax = sns.histplot(data=edad_escolar,
                  x='edad',
                  weights='pondera_dem',
                  bins=5,
                  hue='concurre_museo',
                  multiple='fill')

ax.set(title='Asistencia al museo en edad escolar',
       xlabel = 'Edad',
       ylabel = 'Proporción')

ax.set_yticks([0.15, 0.5])

plt.tight_layout()
plt.savefig('slides/out/edad_escolar.png', dpi=300, transparent=True)


# %%

edad_escolar = encuesta_simple[encuesta_simple['edad'] < 18][encuesta_simple['nivel_estudios'] == 'SECUNDARIA INCOMPLETA']

sns.set(font_scale=2, style="whitegrid")
fig = plt.figure(figsize=(6, 10), dpi=300)

ax = sns.histplot(data=edad_escolar,
                  x='edad',
                  weights='pondera_dem',
                  bins=5,
                  hue='concurre_museo',
                  multiple='fill')

ax.set(title='Asistencia al museo en edad escolar',
       xlabel = 'Edad',
       ylabel = 'Proporción')

ax.set_yticks([0.15, 0.5])

plt.tight_layout()
plt.savefig('slides/out/edad_escolar.png', dpi=300, transparent=True)
