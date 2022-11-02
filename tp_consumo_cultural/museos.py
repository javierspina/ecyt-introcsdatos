import os
import pandas as pd
import seaborn as sns
from matplotlib import pyplot as plt

museos_fname = os.path.join('data_src', 'museos_region.csv')

museosdf = pd.read_csv(museos_fname)

regiones_museos = museosdf.groupby(museosdf.region)['region'].count().to_frame().reset_index(names=['name']).sort_values('region', ascending = False)

sns.set(font_scale=2, style="whitegrid")
fig = plt.figure(figsize=(12, 9))
ax = sns.barplot(y=regiones_museos.name,
                 x=regiones_museos.region)
ax.set(title='Cantidad de museos por región',
       ylabel='Región',
       xlabel='Cantidad de museos')
plt.xlim(0,380)
ax.bar_label(ax.containers[0])

cantmuseosfname = os.path.join('slides', 'out', 'cantidad_museos.png')
plt.tight_layout()

plt.savefig(cantmuseosfname, dpi=300, transparent=True)
