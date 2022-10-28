import os
import pandas as pd

path_enc = os.path.join('/Users', 'javierspina', 'Downloads', 'TP Consumo Cultural', 'encc_2017.csv')

enc = pd.read_csv(path_enc)


orig_cols = os.path.join('/Users', 'javierspina', 'Downloads', 'TP Consumo Cultural', 'orig.csv')

orig = pd.read_csv(orig_cols)


pars_cols = os.path.join('/Users', 'javierspina', 'Downloads', 'TP Consumo Cultural', 'pars.csv')

pars = pd.read_csv(pars_cols)
