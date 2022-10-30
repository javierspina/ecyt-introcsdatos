import os
import numpy as np
import pandas as pd
import seaborn as sns
from matplotlib import pyplot as plt

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

# Ploteo
sns.set(font_scale=2, style="whitegrid")
plt.figure(figsize=(12, 9))
ax = sns.barplot(x=asist_museo_nse_x100.iloc[:-1].index, 
                 y=asist_museo_nse_x100.iloc[:-1].SI)    # iloc[:-1] para no graficar NSE marginal
ax.bar_label(ax.containers[0])    # Agrega labels a las barras
ax.set(xlabel='Nivel Socio-Económico',
       ylabel='Asistencia [% NSE]',
       title='Concurrencia a los museos según Nivel Socio-Económico',
       ylim=(0, 34))
plt.savefig(asist_museo_nse_x100_fname, dpi=100)

#%%