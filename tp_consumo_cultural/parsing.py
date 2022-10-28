import os
import csv
import pandas as pd

def col_names(nombre_archivo):
    with open(nombre_archivo, 'rt') as src:
        cols = csv.reader(src)
        col_list = []
        for col in cols:
            col_list.append(col[0])
        return col_list

orig_cols = os.path.join('/Users', 'javierspina', 'Downloads', 'TP Consumo Cultural', 'orig.csv')
pars_cols = os.path.join('/Users', 'javierspina', 'Downloads', 'TP Consumo Cultural', 'pars.csv')


orig = col_names(orig_cols)
pars = col_names(pars_cols)

a = dict(zip(orig, pars))

path_enc = os.path.join('/Users', 'javierspina', 'Downloads', 'TP Consumo Cultural', 'encc_2017.csv')

path_enc_pars = os.path.join('/Users', 'javierspina', 'Downloads', 'TP Consumo Cultural', 'encc_2017_pars.csv')

enc = pd.read_csv(path_enc).rename(columns = a)


enc.to_csv(path_enc_pars)