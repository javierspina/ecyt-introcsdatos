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
sns.set(font_scale=2, style="whitegrid")
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

sns.move_legend(ax, "upper left", bbox_to_anchor=(1, 1), title='NSE', frameon=True)

ax.set(title='Entradas expedidas según la cantidad de museos', 
       xlabel = 'Museos por región cada 100.000 habitantes',
       ylabel = 'Entradas cada 100.000 habitantes')

modelo_entrada_museo_fname = os.path.join('slides', 'out', 'modelo_entrada_museo.png')
plt.tight_layout()

plt.savefig(modelo_entrada_museo_fname, dpi=100, transparent=True)
