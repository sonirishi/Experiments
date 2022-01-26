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

X_train, X_test, y_train,y_test = train_test_split(X, y,random_state=42, test_size=0.2)e
from sklearn.model_selection import GridSearchCV
model = KNeighborsRegressor()
clf = GridSearchCV(model,{'n_neighbors':[12,15,18,20]})
clf.fit(X_train,y_train)
clf.best_estimator_

model_fin = KNeighborsRegressor(n_neighbors=18)
model_fin.fit(X_train,y_train)

y_pred = model_fin.predict(X_test)
from sklearn.metrics import mean_squared_error
model_fin.score(X_train, y_train)
mean_squared_error(y_test, y_pred)

## bandwidth is proportional to N**(-0.2) hence we need to reverse it
## doesnt seem to work as such
model_hopt = KNeighborsRegressor(n_neighbors=int(18/(1.25)**(0.2)))
model_hopt.fit(X_train,y_train)

y_pred = model_hopt.predict(X_test)
model_hopt.score(X_train, y_train)
mean_squared_error(y_test, y_pred)
