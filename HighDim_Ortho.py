import numpy as np
import sys
import matplotlib.pyplot as plt
sys.path.append('D:/Projects/venv1/Lib/site-packages/')
from scipy.spatial.distance import cosine
from seaborn import kdeplot

angle_hd = list()
angle_ld = list()

for i in range(10000):
    a = np.random.normal(1,2,10000)
    b = np.random.normal(1,2,10000)
    c = np.random.normal(1,2,3)
    d = np.random.normal(1,2,3)
    angle_hd.append(np.abs(cosine(a,b)))
    angle_ld.append(np.abs(cosine(c,d)))

kdeplot(angle_hd)

kdeplot(angle_ld)
