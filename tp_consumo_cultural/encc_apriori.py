import pandas as pd
from mlxtend.frequent_patterns import apriori

import encc_parse
import encc_mappers

encuesta = encc_parse.apply_mappings(save_to_csv = False)

encc_frecs = encuesta.replace(to_replace = encc_mappers.dict_frecs_binary()).fillna(False)
encc_frecs = encc_frecs[encc_frecs['concurre_museo'] == 'SI']

museos = ['frec_museo_historicos',
          'frec_museo_cs_naturales',
          'frec_museo_tecnologia',
          'frec_museo_artes',
          'frec_museo_antropologia_arquelogia',
          'frec_museo_tematicos']

encc_museos = {museo: encc_frecs[encc_frecs[museo] == 1][encc_mappers.frecs] for museo in museos}

frec_items_museos = {m: apriori(e, min_support = 0.1, use_colnames = True) for m, e in encc_museos.items()}

for m, f in frec_items_museos.items():
    f.insert(0, 'Museo', m)

itemsets_concurren = pd.concat([f.sort_values(by = 'support', ascending = False)[:10] for f in frec_items_museos.values()])

nses = ['1- Alto', '2- Medio-Alto', '3- Medio', '4- Medio-Bajo', '5- Bajo']

encc_nses = {nse: encc_frecs[encc_frecs['NSEdenom'] == nse][encc_mappers.frecs] for nse in nses}

frec_items_nses = {m: apriori(e, min_support = 0.1, use_colnames = True) for m, e in encc_nses.items()}

for m, f in frec_items_nses.items():
    f.insert(0, 'NSE', m)

itemsets_por_nse = pd.concat([f.sort_values(by = 'support', ascending = False)[:3] for f in frec_items_nses.values()])
itemsets_por_nse.to_csv('itemsets.csv')

# %%

encc_base = encuesta.replace(to_replace = encc_mappers.dict_frecs_binary()).fillna(False)
encc_no_museo = encc_base[encc_base['concurre_museo'] == 'NO']

encc_no_nses = {nse: encc_no_museo[encc_no_museo['NSEdenom'] == nse][encc_mappers.frecs] for nse in nses}

frec_items_no_nses = {m: apriori(e, min_support = 0.1, use_colnames = True) for m, e in encc_no_nses.items()}

for m, f in frec_items_no_nses.items():
    f.insert(0, 'NSE', m)

itemsets_no_por_nse = pd.concat([f.sort_values(by = 'support', ascending = False)[:3] for f in frec_items_no_nses.values()])

itemsets_no_por_nse.to_csv('itemsets_no_concurrents.csv')

#%%

frec_no_museos = apriori(encc_no_museo, min_support = 0.1, use_colnames = True)

itemsets_no_concurren = frec_no_museos.sort_values(by = 'support', ascending = False)[:10]
