import seaborn as sns
import gc
from multiprocessing import Pool
import matplotlib.pyplot as plt
import os
import random

sns.set(color_codes=True)

arr = []
f = open("sample_abuns.csv",'r')
for lines in f:
    arr.append(lines.rstrip().split(','))

def get_ran(input_arr):
    q = map(lambda x: float(x),input_arr[1:])
    return abs(min(q)-max(q))


q = map(get_ran,arr[1:])
sns.distplot(q)
plt.show()
