import numpy as np
import sys
import matplotlib.pyplot as plt
sys.path.append('D:/Projects/venv1/Lib/site-packages/')
import statsmodels.api as sm

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
res = mod.fit()
beta = res.params[1]
beta_1 = res.params[0]

def getSingleBootstrapMetrics(X,y,B,betahat,feat_no):
    param_list = []
    for i in range(B):
        boot_index = np.random.randint(0,X.shape[0]-1,X.shape[0]-1)
        exog = X[boot_index]
        endog = y[boot_index]
        exog = sm.add_constant(exog, prepend=False)
        mod = sm.OLS(endog,exog)
        res = mod.fit()
        param_list.append(res.params[feat_no])
    CI = [2*betahat - np.quantile(param_list,0.975), 2*betahat - np.quantile(param_list,0.025)]
    p = sum(param_list >= betahat)/B
    return param_list, CI, p, np.std(param_list)

param_list, CI_s, ps, std_err = getSingleBootstrapMetrics(X,y,1000,beta,1)
print(ps)
print(std_err)

def getDoubleBootstrapMetrics(X,y,B1,B2,betahat,feat_no):
    param_list = []
    pboot = []
    metric = []
    for i in range(B1):
        boot_index = np.random.randint(0,X.shape[0]-1,X.shape[0]-1)
        exog = X[boot_index]
        endog = y[boot_index]
        exog = sm.add_constant(exog, prepend=False)
        mod = sm.OLS(endog,exog)
        res = mod.fit()
        param_list.append(res.params[feat_no])
        subparam_list = []
        for j in range(B2):
            boot_index = np.random.randint(0,exog.shape[0]-1,exog.shape[0]-1)
            exog1 = exog[boot_index]
            endog1 = endog[boot_index]
            exog1 = sm.add_constant(exog1, prepend=False)
            mod = sm.OLS(endog1,exog1)
            res_boot = mod.fit()
            subparam_list.append(res_boot.params[feat_no])
        metric.extend((subparam_list - res.params[feat_no])/np.std(subparam_list))
        pboot.append(sum(subparam_list >= res.params[feat_no])/B2)
    sd_betahat = np.std(param_list)
    CI = [betahat - sd_betahat*np.quantile(metric,0.975),betahat - sd_betahat*np.quantile(metric,0.025)]
    p = sum(param_list >= betahat)/B1
    padj = sum(pboot <= p)/B1
    return sd_betahat, CI, p, padj

sd_betahat, CI, p, padj = getDoubleBootstrapMetrics(X,y,1000,1000,beta,1)
print(sd_betahat,CI,p,padj)
print(CI_s,ps)

print(res.summary2())

param_list, CI_s, ps, std_err = getSingleBootstrapMetrics(X,y,1000,beta_1,0)

print(CI_s)
std_err
print(ps)

sd_betahat, CI, p, padj = getDoubleBootstrapMetrics(X,y,100,100,beta_1,0)

boston_df = pd.read_csv('Boston.csv')
boston_df.columns

boston_df.isnull().sum()
X = boston_df.drop(["MEDV",'CAT. MEDV', 'Unnamed: 15','Unnamed: 16'], axis=1)
X = X.values
y = boston_df["MEDV"]
y = y.values

exog = sm.add_constant(X, prepend=False)
mod = sm.OLS(y,exog)
res = mod.fit()
a1 = res.params[1]
a2 = res.params[2]

param_list, CI_s, ps, std_err = getSingleBootstrapMetrics(X,y,1000,a1,1)
print(ps)
print(CI_s)

np.quantile(param_list,[0.01,0.025, 0.05,0.1,0.25,0.5,0.75,0.9,0.95,0.975, 0.99,1])

res.summary()

param_list, CI_s, ps, std_err = getSingleBootstrapMetrics(X,y,1000,a2,2)
print(ps)
print(CI_s)

sd_betahat, CI, p, padj = getDoubleBootstrapMetrics(X,y,100,100,a1,1)
print(p,CI,padj)

sd_betahat, CI, p, padj = getDoubleBootstrapMetrics(X,y,100,100,a2,2)
print(p,CI,padj)
