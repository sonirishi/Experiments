import sys
import matplotlib.pyplot as plt
sys.path.append('D:/Projects/venv1/Lib/site-packages/')
from sklearn.datasets import load_iris
from sklearn.decomposition import PCA
import pandas as pd
# import some data to play with
iris = load_iris()
from sklearn.preprocessing import StandardScaler
iris = iris.data
iris = StandardScaler().fit_transform(iris)
iris[0:5,]
model = PCA(n_components=4)
model.fit(iris)
np.sum(model.explained_variance_)
covar = np.cov(np.transpose(iris))
covar.shape
np.sum(np.diag(covar))
new = model.transform(iris)
new_cov = np.cov(np.transpose(new))
np.diag(new_cov)
model.explained_variance_
new_cov[0,0]/np.sum(np.diag(new_cov))

from sklearn.decomposition import SparsePCA
model2 = SparsePCA(n_components=4,alpha=0.005)
model2.fit(iris)
transformed = model2.transform(iris)
t_cov = np.cov(np.transpose(transformed))
np.diag(t_cov)
model2.components_
t_cov[0,0]/np.sum(np.diag(t_cov))
