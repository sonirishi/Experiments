import sys
sys.path.append('D:/Projects/venv1/Lib/site-packages/')
import pandas as pd; from sklearn.ensemble import GradientBoostingRegressor
import numpy as np
loc = 'D:/Projects/'
df = pd.read_csv(loc+'weatherHistory.csv')
df.head(2)
ntrees = 200
depth = 8
lr = 0.01
gbdt = GradientBoostingRegressor(learning_rate=lr,n_estimators=ntrees,max_depth=depth)
df.shape
df['Formatted Date'].min()
df['year'] = df['Formatted Date'].map(lambda x: x[0:4])
df.dtypes
df['year'] = df['year'].astype(int)
df_train = df.loc[df['year'] <= 2014,].reset_index(drop=True)
df_test = df.loc[df['year'] > 2014,].reset_index(drop=True)
df_train.shape
df_test.shape
import seaborn as sns
sns.kdeplot(df_train['Apparent Temperature (C)'])
gbdt.fit(y=df_train['Apparent Temperature (C)'],X=df_train[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']])
from sklearn.metrics import r2_score
r2_score(df_train['Apparent Temperature (C)'], gbdt.predict(df_train[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']]))
r2_score(df_test['Apparent Temperature (C)'], gbdt.predict(df_test[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']]))
ypred = np.zeros((df_train.shape[0],ntrees))
ypred[:,0] = np.median(df_train['Apparent Temperature (C)'])
df_pred = np.zeros((df_train.shape[0],ntrees-1))
df_node = np.zeros((df_train.shape[0],ntrees-1))
df_gamma = np.zeros((df_train.shape[0],ntrees-1))
from sklearn.tree import DecisionTreeRegressor
for i in range(ntrees-1):
    yt = np.sign(df_train['Apparent Temperature (C)'] - ypred[:,i])
    #print(yt.shape)
    globals()[f"tree_{i}"] = DecisionTreeRegressor(max_depth=depth)
    globals()[f"tree_{i}"].fit(y=yt,X=df_train[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']])
    df_node[:,i] = globals()[f"tree_{i}"].apply(df_train[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']])
    temp_df = pd.concat((pd.DataFrame(df_node[:,i]),pd.DataFrame(ypred[:,i])),axis=1)
    temp_df = pd.concat((temp_df,pd.DataFrame(df_train['Apparent Temperature (C)'])),axis=1)
    temp_df.columns = ['node','out','act']
    #print(temp_df.iloc[76307,])
    temp_df['diff'] = temp_df['act'] - temp_df['out']
    globals()[f"med_{i}"] = temp_df.groupby('node',as_index=False).agg({'diff':np.median})
    #print(med.head())
    globals()[f"med_{i}"].rename(columns={'diff':'gamma'},inplace=True)
    temp_df = pd.merge(temp_df,globals()[f"med_{i}"],on='node',how='left')
    #print(temp_df.iloc[76307,])
    df_gamma[:,i] = temp_df['gamma']
    ypred[:,i+1] = ypred[:,i] + lr*df_gamma[:,i]
r2_score(df_train['Apparent Temperature (C)'],ypred[:,199])

ypred_test = np.zeros((df_test.shape[0],ntrees))
ypred_test[:,0] = np.median(df_test['Apparent Temperature (C)'])
df_gamma_test = np.zeros((df_test.shape[0],ntrees-1))
for i in range(ntrees-1):
    df_node_test = globals()[f"tree_{i}"].apply(df_test[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']])
    df_node_test = pd.DataFrame(df_node_test); df_node_test.columns = ['node']
    df_node_test = pd.merge(df_node_test,globals()[f"med_{i}"],on='node',how='left')
    df_gamma_test[:,i] = df_node_test['gamma']
    ypred_test[:,i+1] = ypred_test[:,i] + lr*df_gamma_test[:,i]
r2_score(df_test['Apparent Temperature (C)'],ypred_test[:,199])
