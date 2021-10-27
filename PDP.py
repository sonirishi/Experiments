import numpy as np
import sys
import matplotlib.pyplot as plt
sys.path.append('D:/Projects/venv1/Lib/site-packages/')
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestRegressor
import pandas as pd
# import some data to play with
iris = load_iris()
X = iris.data
y = iris.target
model = RandomForestRegressor(n_estimators=100,max_depth=8,random_state=42)
model.fit(X,y)
from sklearn.inspection import partial_dependence
dict1 = partial_dependence(model,X,[0],kind='average',method='brute')

len(dict1['average'][0])
len(dict1['values'][0])
from copy import deepcopy

predy = {}
for val in dict1['values'][0]:
    X_temp = deepcopy(X)
    X_temp[:,0] = val
    y = model.predict(X_temp)
    predy[val] = np.mean(y)

predy
dict1['values']
dict1['average']

from sklearn.inspection import PartialDependenceDisplay
PartialDependenceDisplay.from_estimator(model,X,[0])
