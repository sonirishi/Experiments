import numpy as np
import sys
import matplotlib.pyplot as plt
sys.path.append('D:/Projects/venv1/Lib/site-packages/')
import statsmodels.api as sm
from sklearn.model_selection import KFold
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error

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

X = abalone.drop("Rings", axis=1)
X = X.values
y = abalone["Rings"]
y = y.values

exog = sm.add_constant(X, prepend=False)
mod = sm.OLS(y,exog)

from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y,random_state=42, test_size=0.2)

def doRepeatedKFold(X_train,y_train,repeats,folds):
    param_store = pd.DataFrame(columns=['fold','repeat','metrics'])
    counter = 0
    for j in range(repeats):
        kf = KFold(n_splits=folds,random_state=j*np.random.randint(1,1000,1)[0],shuffle=True)
        for i, (train_index, test_index) in enumerate(kf.split(X_train)):
            Xcv_train, Xcv_test = X_train[train_index], X_train[test_index]
            ycv_train, ycv_test = y_train[train_index], y_train[test_index]
            exog = sm.add_constant(Xcv_train, prepend=False)
            model = sm.OLS(ycv_train,exog).fit()
            exog_test = sm.add_constant(Xcv_test, prepend=False)
            y_pred = model.predict(exog_test)
            param_store.loc[counter,'metrics'] = mean_squared_error(ycv_test, y_pred)
            param_store.loc[counter,'fold'] = i
            param_store.loc[counter,'repeat'] = j
            counter += 1
    return param_store

cv_store = doRepeatedKFold(X_train,y_train,100,10)
print(cv_store.metrics.mean())
print(cv_store.metrics.std())

def doBootstrapValidation(X_train,y_train,B):
    exog = sm.add_constant(X_train, prepend=False)
    model = sm.OLS(y_train,exog).fit()
    y_pred = model.predict(exog)
    rmse_orig = mean_squared_error(y_train, y_pred)
    optimism = []
    index = [*range(0,X_train.shape[0])]
    rmse_boot_list = []
    rmse_b_orig_list = []
    for i in range(B):
        boot_index = np.random.choice(index, size=X_train.shape[0], replace=True)
        exog = X_train[boot_index]
        endog = y_train[boot_index]
        ## build bootstrap model
        exog = sm.add_constant(exog, prepend=False)
        model = sm.OLS(endog,exog).fit()
        y_pred = model.predict(exog)
        ### Get boostrap error
        rmse_boot = mean_squared_error(endog, y_pred)
        ## Get overall data error
        exog = sm.add_constant(X_train, prepend=False)
        y_pred = model.predict(exog)
        rmse_b_orig = mean_squared_error(y_train, y_pred)
        rmse_boot_list.append(rmse_boot_list)
        rmse_b_orig_list.append(rmse_b_orig)
        optimism.append((rmse_boot - rmse_b_orig))
    return rmse_orig, rmse_orig - np.mean(optimism), optimism

rmse_orig, error_metric, optimism = doBootstrapValidation(X_train,y_train,200)

print(error_metric)
print(rmse_orig)
print(np.mean(optimism))
print(len([element for element in optimism if element < 0]))

print(np.mean([element for element in optimism if element < 0]))
print(np.mean([element for element in optimism if element > 0]))
