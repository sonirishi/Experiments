import sys
sys.path.append('D:/Projects/venv1/Lib/site-packages/')
import pandas as pd; from sklearn.ensemble import GradientBoostingRegressor
import numpy as np
loc = 'D:/Projects/'
df = pd.read_csv(loc+'weatherHistory.csv')
df['year'] = df['Formatted Date'].map(lambda x: x[0:4])
df['year'] = df['year'].astype(int)
df_train = df.loc[df['year'] <= 2014,].reset_index(drop=True)
df_test = df.loc[df['year'] > 2014,].reset_index(drop=True)
df_train.shape
df_test.shape

from sklearn.metrics import r2_score
ntrees = 200
depth = 8
lr = 0.02
# Huber Boost Code
quantile = 0.90
ypred = np.zeros((df_train.shape[0],ntrees))
ypred[:,0] = np.median(df_train['Apparent Temperature (C)'])
df_pred = np.zeros((df_train.shape[0],ntrees-1))
df_node = np.zeros((df_train.shape[0],ntrees-1))
df_gamma = np.zeros((df_train.shape[0],ntrees-1))
from sklearn.tree import DecisionTreeRegressor
for i in range(ntrees-1):
    rt = df_train['Apparent Temperature (C)'] - ypred[:,i]
    delta = np.quantile(np.abs(rt),quantile)
    ynew = [val if val <= delta else delta*np.sign(val) for val in np.abs(rt)]
    #print(yt.shape)
    globals()[f"tree_{i}"] = DecisionTreeRegressor(max_depth=depth)
    globals()[f"tree_{i}"].fit(y=ynew,X=df_train[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']])
    df_node[:,i] = globals()[f"tree_{i}"].apply(df_train[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']])
    temp_df = pd.concat((pd.DataFrame(df_node[:,i]),pd.DataFrame(rt)),axis=1)
    temp_df.columns = ['node','rt']
    globals()[f"med_{i}"] = temp_df.groupby('node',as_index=False).agg({'rt':np.median})
    globals()[f"med_{i}"].rename(columns={'rt':'rthat'},inplace=True)
    N_node = temp_df.groupby('node',as_index=False).agg({'rt':'count'})
    N_node.rename(columns={'rt':'count_row'},inplace=True)
    temp_df = pd.merge(temp_df,globals()[f"med_{i}"],on='node',how='left')
    temp_df = pd.merge(temp_df,N_node,on='node',how='left')
    temp_df['rminrhat'] = temp_df['rt'] - temp_df['rthat']
    temp_df['absrminrhat'] = np.abs(temp_df['rt'] - temp_df['rthat'])
    temp_df['minval'] = np.minimum(delta,temp_df['absrminrhat'])
    temp_df['sign_diff'] = np.sign(temp_df['rminrhat'])
    temp_df['fin'] = temp_df['sign_diff']*temp_df['minval']
    #print(temp_df.columns)
    newtemp = temp_df.groupby('node',as_index=False).agg({'fin':'sum'})
    newtemp.rename(columns={'fin':'grpfin'},inplace=True)
    temp_df = pd.merge(temp_df,newtemp,on='node',how='left')
    temp_df['grpfin'] = temp_df['grpfin']/temp_df['count_row']
    temp_df['gamma'] = temp_df['grpfin'] + temp_df['rthat']
    #print(temp_df.iloc[76307,])
    globals()[f"med_{i}"] = temp_df.drop_duplicates(subset='node')
    df_gamma[:,i] = temp_df['gamma']
    ypred[:,i+1] = ypred[:,i] + lr*df_gamma[:,i]
r2_score(df_train['Apparent Temperature (C)'],ypred[:,199])

ypred_test = np.zeros((df_test.shape[0],ntrees))
ypred_test[:,0] = np.median(df_test['Apparent Temperature (C)'])
df_gamma_test = np.zeros((df_test.shape[0],ntrees-1))
for i in range(ntrees-1):
    df_node_test = globals()[f"tree_{i}"].apply(df_test[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']])
    df_node_test = pd.DataFrame(df_node_test); df_node_test.columns = ['node']
    #print(globals()[f"med_{i}"].shape)
    df_node_test = pd.merge(df_node_test,globals()[f"med_{i}"],on='node',how='left')
    df_gamma_test[:,i] = df_node_test['gamma']
    ypred_test[:,i+1] = ypred_test[:,i] + lr*df_gamma_test[:,i]
r2_score(df_test['Apparent Temperature (C)'],ypred_test[:,199])
