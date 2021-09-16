import sys
sys.path.append('D:/Projects/venv1/Lib/site-packages/')
import pandas as pd; from catboost import CatBoostRegressor
import numpy as np
loc = 'D:/Projects/'
df = pd.read_csv(loc+'weatherHistory.csv')

df.head()

ntrees = 200
depth = 6
lr = 0.01
gbdt = CatBoostRegressor(learning_rate=lr,iterations=ntrees,depth=depth,random_seed=42)
df.shape
df['Formatted Date'].min()
df['year'] = df['Formatted Date'].map(lambda x: x[0:4])

df['year'] = df['year'].astype(int)
df_train = df.loc[df['year'] <= 2014,].reset_index(drop=True)
df_test = df.loc[df['year'] > 2014,].reset_index(drop=True)

model = gbdt.fit(y=df_train['Apparent Temperature (C)'],X=df_train[['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']],verbose=0)

feat_import = model.get_feature_importance(prettified=True)
type(feat_import)
feat_import
from sklearn.utils import shuffle
from scipy.stats import percentileofscore
feat_import.rename(columns={'Importances':'actual_imp'},inplace=True)

def getPermutationPvalue(runs,df_train,feature_list,target):
    permute_imp = pd.DataFrame({"Feature Id":feature_list})
    pvalue = pd.DataFrame({"Feature Id":feature_list,"p_value":[0]*len(feature_list)})
    for i in range(runs):
        shuffled_y = shuffle(df_train[target],random_state=i).reset_index(drop=True)
        temp_model = CatBoostRegressor(learning_rate=lr,iterations=ntrees,depth=depth,random_seed=42)
        temp_model.fit(y=shuffled_y,X=df_train[feature_list],verbose=0)
        temp_feat =  temp_model.get_feature_importance(prettified=True)
        temp_feat.rename(columns={'Importances':f"run_{i}"},inplace=True)
        permute_imp = pd.merge(permute_imp,temp_feat,on='Feature Id',how='left')
        for i in range(permute_imp.shape[0]):
            pvalue.iloc[i,1] = 1- percentileofscore(permute_imp.iloc[0,1:], feat_import.iloc[i,1], kind='mean')/100
    return(pvalue)

feature_list = ['Humidity','Wind Speed (km/h)','Wind Bearing (degrees)']
permute_imp.shape
target = 'Apparent Temperature (C)'

getPermutationPvalue(100,df_train,feature_list,target)
