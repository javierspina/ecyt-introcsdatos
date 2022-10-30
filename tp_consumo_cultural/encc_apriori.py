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

itemsets = pd.concat([f.sort_values(by = 'support', ascending = False)[:10] for f in frec_items_museos.values()])

