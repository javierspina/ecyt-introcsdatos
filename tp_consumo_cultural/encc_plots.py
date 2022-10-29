import numpy as np
import pandas as pd
import seaborn as sns

import encc_parse

encuesta = encc_parse.apply_mappings(save_to_csv = False)

a = pd.pivot_table(encuesta,
               values='pondera_dem',
               index='NSEdenom',
               columns='concurre_museo',
               aggfunc=np.sum
               )