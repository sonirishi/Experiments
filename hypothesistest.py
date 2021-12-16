x1 = [99, 99.5, 65, 100, 99, 99.5, 99, 99.5, 99.5, 57, 100, 99.5,
        99.5, 99, 99, 99.5, 89.5, 99.5, 100, 99.5]
y1 = [99, 99.5, 99.5, 0, 50, 100, 99.5, 99.5, 0, 99.5, 99.5, 90,
        80, 0, 99, 0, 74.5, 0, 100, 49.5]
import sys
import matplotlib.pyplot as plt
sys.path.append('D:/Projects/venv1/Lib/site-packages/')
from seaborn import kdeplot

kdeplot(x1)
kdeplot(y1)
