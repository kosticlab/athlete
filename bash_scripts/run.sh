#!/bin/bash
grep $1 ru2.clstr | cut -f2 > $1
head -1 ru2.csv > $1_ra.csv
python find_cags.py $1 ru2.csv $1_ra.csv
Rscript plot.R $1
