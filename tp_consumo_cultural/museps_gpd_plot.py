import os
import pandas as pd
from matplotlib import pyplot as plt
import geopandas as gpd
from mpl_toolkits.axes_grid1.inset_locator import zoomed_inset_axes
from mpl_toolkits.axes_grid1.inset_locator import mark_inset

#%%
shp_arg = os.path.join('provincias', 'provincias.shp')
map_df = gpd.read_file(shp_arg)

museos_fname = os.path.join('data_src', 'museos_datosabiertos.csv')
museos = pd.read_csv(museos_fname)
museos['provincia'] = museos['provincia'].apply(lambda x: x.strip())


regiones_fname = os.path.join('data_src', 'provincias.csv')
regiones = pd.read_csv(regiones_fname, delimiter=';')

museos = museos.merge(regiones, on='provincia', how='left')
map_df = map_df.merge(regiones, left_on='NAM', right_on='provincia', how='left')

museos_gpd = gpd.GeoDataFrame(museos, geometry=gpd.points_from_xy(museos.Longitud, museos.Latitud))


#%%
fig, ax = plt.subplots(1, 1, dpi=600, figsize=(9,16))

plt.axis('off')

ax.axis([-76, -52, -57, -20])

map_df.plot(column = 'region',
            alpha = 0.5,
            edgecolor = 'black',
            ax = ax, 
            aspect='equal')

museos_gpd.plot(ax=ax, color='red')

axins = zoomed_inset_axes(ax, 20, loc=5)

museos_gpd[museos_gpd['provincia'] == 'Ciudad Autónoma de Buenos Aires'].plot(ax=axins, color='red')

axins.set_yticks([])
axins.set_xticks([])

minx,miny,maxx,maxy =  map_df.query('NAM == "Ciudad Autónoma de Buenos Aires"').total_bounds
axins.set_xlim(minx, maxx)
axins.set_ylim(miny, maxy)
map_df.query('NAM == "Ciudad Autónoma de Buenos Aires"').plot(alpha=0.5, ax=axins, edgecolor='black', column='region')

mark_inset(ax, axins, loc1=3, loc2=1, fc="none", ec="0.5")

plt.setp(axins.get_xticklabels(), visible=False)
plt.setp(axins.get_yticklabels(), visible=False)

# plt.show()
plt.savefig(os.path.join('slides', 'out', 'museos_datosabiertos.png'), dpi=600)

