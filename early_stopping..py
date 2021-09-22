import sys
sys.path.append('D:/Projects/venv1/Lib/site-packages/')
import pandas as pd; import scipy as scp
import numpy as np
from catboost import CatBoostRegressor, Pool

loc = 'D:/Projects/'
df = pd.read_csv(loc+'weatherHistory.csv')

ntrees = 1000
lr = 0.03
depth = 6
gbdt = CatBoostRegressor(learning_rate=lr,iterations=ntrees,depth=depth,random_seed=42)
df.shape
df['Formatted Date'].max()
df['year'] = df['Formatted Date'].map(lambda x: x[0:4])

df['year'] = df['year'].astype(int)
df_train = df.loc[df['year'] <= 2013,].reset_index(drop=True)
df_val = df.loc[(df['year'] >= 2014) & (df['year'] <= 2015),].reset_index(drop=True)
df_test = df.loc[df['year'] > 2015,].reset_index(drop=True)
eval_pool = [(df_val[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']], df_val['Apparent Temperature (C)'])]
model = gbdt.fit(y=df_train['Apparent Temperature (C)'],
X=df_train[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']],
use_best_model=True,verbose=True,early_stopping_rounds=20,eval_set=eval_pool)

gbdt = CatBoostRegressor(learning_rate=lr,iterations=346,depth=depth,random_seed=42)

model = gbdt.fit(y=df_train['Apparent Temperature (C)'],
X=df_train[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']],
use_best_model=True,verbose=0,early_stopping_rounds=20,eval_set=eval_pool)

model.get_feature_importance(prettified=True)

from sklearn.metrics import mean_squared_error

gbdt = CatBoostRegressor(learning_rate=lr,iterations=ntrees,depth=depth,random_seed=42)

model = gbdt.fit(y=df_train['Apparent Temperature (C)'],
X=df_train[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']],
verbose=0,eval_set=eval_pool)

val_scores = model.get_evals_result()['validation']['RMSE']
train_scores = model.get_evals_result()['learn']['RMSE']

np.where(val_scores==np.min(val_scores))
np.min(val_scores)
val_scores[346]
val_scores[870]
train_scores[870]
train_scores[346]

minidx = np.where(val_scores==np.min(val_scores))[0][0]
minval = np.min(val_scores)
metric = dict()

def earlystop_pq(minidx,minval,strip):
    for i in range(minidx+1,ntrees,strip):
        val_strip = val_scores[i:i+strip]
        min = np.min(val_strip)
        avg = np.average(val_strip)
        pt = 1000*(avg/min-1)
        val_err = val_strip[-1]
        gl = 100*(val_err/minval-1)
        pq = gl/pt
        metric[i] = pq
    return metric

fintrees = earlystop_pq(minidx,minval,5)


gbdt = CatBoostRegressor(learning_rate=lr,iterations=346,depth=depth,random_seed=42)

model = gbdt.fit(y=df_train['Apparent Temperature (C)'],
X=df_train[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']],
verbose=0,eval_set=eval_pool)

mean_squared_error(df_test['Apparent Temperature (C)'],model.predict(df_test[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']]))

mean_squared_error(df_val['Apparent Temperature (C)'],model.predict(df_val[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']]))

mean_squared_error(df_train['Apparent Temperature (C)'],model.predict(df_train[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']]))


gbdt = CatBoostRegressor(learning_rate=lr,iterations=901,depth=depth,random_seed=42)

model = gbdt.fit(y=df_train['Apparent Temperature (C)'],
X=df_train[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']],
verbose=0,eval_set=eval_pool)

mean_squared_error(df_test['Apparent Temperature (C)'],model.predict(df_test[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']]))

mean_squared_error(df_val['Apparent Temperature (C)'],model.predict(df_val[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']]))

mean_squared_error(df_train['Apparent Temperature (C)'],model.predict(df_train[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']]))
