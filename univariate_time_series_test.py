import sys
sys.path.append('D:/Projects/venv1/Lib/site-packages/')
import pandas as pd; import numpy as np
import statsmodels.api as sm
import plotly.express as px
from statsmodels.graphics.tsaplots import plot_acf

df = pd.read_csv('D:/Projects/Sunspots.csv')

df.head()

px.line(df['Monthly Mean Total Sunspot Number'])

plot_acf(df['Monthly Mean Total Sunspot Number']);  #semicolon suppresses multiple outputs

plot_acf(np.diff(df['Monthly Mean Total Sunspot Number']));


df['lag_1'] = df['Monthly Mean Total Sunspot Number'].shift(1)

df['new_series'] = df['Monthly Mean Total Sunspot Number'] - df['lag_1']

df['lag_new'] = df['new_series'].shift(1)

df.head()

df_1 = df.loc[pd.notnull(df['lag_new']),].reset_index(drop=True)

X = df_1['lag_new']
X = sm.add_constant(X)

obj = sm.OLS(endog=df_1['new_series'],exog=X)

result = obj.fit()
result.params['lag_new']
result.summary()

plot_acf(result.resid);
from statsmodels.tsa.arima.model import ARIMA

mod = ARIMA(endog=df['Monthly Mean Total Sunspot Number'],order=(1,1,0)).fit()

mod.summary()

plot_acf(mod.resid);

mod.params['ar.L1']

params_reg = np.zeros((10000,1))

for i in range(10000):
    df_boot = df_1.sample(frac=1,replace=True, random_state=1988+i)
    X = df_boot['lag_new']
    X = sm.add_constant(X)
    obj = sm.OLS(endog=df_boot['new_series'],exog=X).fit()
    params_reg[i,0] = obj.params['lag_new']

np.mean(params_reg)
np.std(params_reg)

params_reg1 = np.zeros((10000,1))

block=56

from arch.bootstrap import StationaryBootstrap
from arch.bootstrap import optimal_block_length
bs = StationaryBootstrap(block,df_1)

optimal_block_length(df_1['new_series'])

def reg(df_1):
    X = df_1['lag_new']
    X = sm.add_constant(X)
    obj = sm.OLS(endog=df_1['new_series'],exog=X).fit()
    params_reg = obj.params['lag_new']
    return params_reg

def arima(df):
    mod = ARIMA(endog=df['Monthly Mean Total Sunspot Number'],order=(1,1,0)).fit()
    return mod.params['ar.L1']

results = bs.apply(reg,10000)

np.mean(results)
np.std(results)

px.histogram(results)

np.mean(results)
np.std(results)

px.histogram(results)
