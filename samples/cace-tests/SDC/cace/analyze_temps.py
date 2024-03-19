import warnings

warnings.filterwarnings("ignore", category=DeprecationWarning)

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

thres = 0.2


def func(filename: str):
    df = pd.read_fwf(filename)

    df.loc[df["dout"] > thres, "dout"] = 1.8
    df.loc[df["dout"] <= thres, "dout"] = 0

    print(df["dout"].mean())


import sys

print(sys.argv)
