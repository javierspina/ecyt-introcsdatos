import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# %% Cargar Archivos
demograf_fname = os.path.join('data_src', 'full_demograf.csv')
demograf = pd.read_csv(demograf_fname)


# %%
sns.set(font_scale=2, style="whitegrid")
fig = plt.figure(figsize=(12, 9))

ax = sns.histplot(data=demograf, x='edad', hue='concurre_museo', multiple='stack', bins=50, kde=True)
