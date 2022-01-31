import numpy as np
import sys
import matplotlib.pyplot as plt
sys.path.append('D:/Projects/venv1/Lib/site-packages/')
from sklearn.neighbors import KNeighborsRegressor

import pandas as pd
url = ("https://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data")
abalone = pd.read_csv(url, header=None)

abalone.columns = [
"Sex",
"Length",
"Diameter",
"Height",
"Whole weight",
"Shucked weight",
"Viscera weight",
"Shell weight",
"Rings"]

abalone = abalone.drop("Sex", axis=1)

abalone.shape

from sklearn.model_selection import train_test_split

X = abalone.drop("Rings", axis=1)
X = X.values
y = abalone["Rings"]
y = y.values

X_train, X_test, y_train, y_test = train_test_split(X, y,random_state=42, test_size=0.2)
from sklearn.model_selection import KFold
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error

def getParams(X_train,y_train,neigh_list):
    kf = KFold(n_splits=5)
    param_store = pd.DataFrame(columns=['fold','neighbor','metrics'])
    counter = 0
    for i, (train_index, test_index) in enumerate(kf.split(X_train)):
        Xcv_train, Xcv_test = X_train[train_index], X_train[test_index]
        ycv_train, ycv_test = y_train[train_index], y_train[test_index]
        for k in neigh_list:
            model = KNeighborsRegressor(n_neighbors=k)
            counter += 1
            scl = StandardScaler()
            scl_Xcv_train = scl.fit_transform(Xcv_train)
            scl_Xcv_test = scl.transform(Xcv_test)
            model.fit(scl_Xcv_train,ycv_train)
            y_pred = model.predict(scl_Xcv_test)
            param_store.loc[counter,'metrics'] = mean_squared_error(ycv_test, y_pred)
            param_store.loc[counter,'fold'] = i
            param_store.loc[counter,'neighbor'] = k
    return param_store

from copy import deepcopy

param_df = getParams(deepcopy(X_train),deepcopy(y_train),[10,15,20,25])

param_df.groupby('neighbor',as_index=False)['metrics'].mean()

param_df.groupby('neighbor',as_index=False)['metrics'].std()

param_df_1 = getParams(deepcopy(X_train),deepcopy(y_train),[12,15,18])

param_df_1.groupby('neighbor',as_index=False)['metrics'].mean()

def getModel(X_train,y_train,X_test,y_test,k):
    print(f"Running KNN for {k}")
    final_model = KNeighborsRegressor(n_neighbors=k)
    scl = StandardScaler()
    scl_X_train = scl.fit_transform(X_train)
    scl_X_test = scl.transform(X_test)
    final_model.fit(scl_X_train,y_train)
    y_pred = final_model.predict(scl_X_test)
    return mean_squared_error(y_test, y_pred)

getModel(X_train,y_train,X_test,y_test,15)

getModel(X_train,y_train,X_test,y_test,int(15/(1.25)**0.2)) ## didnt work :(

getModel(X_train,y_train,X_test,y_test,16)
