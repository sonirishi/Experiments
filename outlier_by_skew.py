import sys
sys.path.append('D:/Projects/venv1/Lib/site-packages/')
import pandas as pd; import scipy as scp
import numpy as np
import warnings
warnings.filterwarnings("error")

def getNPSkew(df,col):
    arr = sorted(df[col],reverse=True)
    median_val = np.median(arr)
    xscale = 2*np.max(np.abs(arr))
    Zplus = [(x - median_val)/xscale for x in arr if x >= median_val]
    Zminus = [(x - median_val)/xscale for x in arr if x <= median_val]
    p = np.size(Zplus)
    q = np.size(Zminus)
    def kernel(i,j):
        a = Zplus[i]
        b = Zminus[j]
        if a == b:
            return np.sign(p-1-i-j)
        else:
            try:
                return (a+b)/(a-b)
            except:
                print(a,b)
    return np.median([kernel(i,j) for i in range(p) for j in range(q)])

df = pd.read_csv('D:/Projects/Sunspots.csv')

import plotly.express as px

px.box(df['Monthly Mean Total Sunspot Number'])

df.loc[df['Monthly Mean Total Sunspot Number'] > 270].shape

np.median(df['Monthly Mean Total Sunspot Number'])

skew_np = getNPSkew(df,'Monthly Mean Total Sunspot Number')
skew_np

from scipy.stats import skew, iqr
skew(df['Monthly Mean Total Sunspot Number'])
from seaborn import kdeplot
kdeplot(df['Monthly Mean Total Sunspot Number'])

iqr_d = iqr(df['Monthly Mean Total Sunspot Number'])

low_bound = df['Monthly Mean Total Sunspot Number'].quantile(0.25) - 1.5*np.exp(-3*skew_np)*iqr_d
up_bound = df['Monthly Mean Total Sunspot Number'].quantile(0.75) + 1.5*np.exp(4*skew_np)*iqr_d

df.loc[(df['Monthly Mean Total Sunspot Number'] < low_bound) | (df['Monthly Mean Total Sunspot Number'] > up_bound),].shape

low_bound = df['Monthly Mean Total Sunspot Number'].quantile(0.25) - 1.5*iqr_d
up_bound = df['Monthly Mean Total Sunspot Number'].quantile(0.75) + 1.5*iqr_d

df.loc[(df['Monthly Mean Total Sunspot Number'] < low_bound) | (df['Monthly Mean Total Sunspot Number'] > up_bound),].shape
