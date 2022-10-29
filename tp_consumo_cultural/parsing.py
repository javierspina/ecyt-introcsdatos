import os
import csv
from pandas import DataFrame
from pandas import read_csv

import encc_mappers


def colnames(nombre_archivo):
    with open(nombre_archivo, 'rt') as src:
        cols = csv.reader(src)
        col_list = []
        for col in cols:
            col_list.append(col[0])
        return col_list

def map_colnames():
    fname_cols = os.path.join('.', 'data_src', 'cols_encc.csv')
    fname_pars = os.path.join('.', 'data_src', 'cols_pars.csv')
    orig = colnames(fname_cols)
    pars = colnames(fname_pars)
    return dict(zip(orig, pars))

def save_encc(df):
    fname = os.path.join('.', 'data_src', 'encc_2017_parsedcols.csv')
    df.to_csv(fname, index = False)

def parse_encc(save_to_csv:bool = True) -> DataFrame:
    # Lectura y limpieza
    fname_encc = os.path.join('.', 'data_src', 'encc_2017.csv')
    df = read_csv(fname_encc, dtype=str)
    df = df.drop(labels=[1949, 2739])
    df = df.rename(columns = map_colnames())
    
    # Guardar archivo
    if save_to_csv:
        save_encc(df)

    return df.set_index('id')

def apply_mappings(save_to_csv:bool = True):
    df = parse_encc(save_to_csv = False)
    df = df.assign(NSEdenom = encc_mappers.nse_denom)
    
    # Guardar archivo
    if save_to_csv:
        save_encc(df)
        
    return df

encc = apply_mappings()