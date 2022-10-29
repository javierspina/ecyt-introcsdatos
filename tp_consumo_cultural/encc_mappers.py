from pandas import DataFrame
from pandas import Series

numerics = [
    'pondera_dem',
    'edad',
    'NSEpuntaje',
    'minutos_radio_1',
    'minutos_radio_total',
    'horas_radio_total',
    'minutos_musica_1',
    'minutos_musica_total',
    'horas_musica_total',
    'minutos_diario_1',
    'minutos_diario_total',
    'horas_diario_total',
    'minutos_tv_1',
    'minutos_tv_total',
    'horas_tv_total',
    'minutos_internet_1',
    'minutos_internet_total',
    'horas_internet_total',
    'minutos_redes_1',
    'minutos_redes_total',
    'horas_redes_total',
    'minutos_videojuegos_1',
    'minutos_videojuegos_total',
    'horas_videojuegos_total'
    ]

def nse_denom(df:DataFrame) -> Series:
    mapper = {
        'AB': '1- Alto',
        'C1': '1- Alto',
        'C2': '2- Medio-Alto',
        'C3': '3- Medio',
        'D1': '4- Medio-Bajo',
        'D2': '5- Bajo',
        'E': '6- Marginal'
        }
    return df['NSEcat1'].map(mapper)