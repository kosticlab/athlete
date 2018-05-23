import os
import sys
from scipy import stats

before = set()
after = set()

meta = []
metadata = open(sys.argv[1],'r')
for lines in metadata:
    meta.append(lines.rstrip().split(','))
#meta = meta[1:]
for elem in meta:
    if elem[11] == "Before":
        before.add(elem[0])
    if elem[11] == "After":
        after.add(elem[0])

print before
print after


abun = []
abundances = open(sys.argv[2],'r')
for lines in abundances:
    abun.append(lines.rstrip().split(','))

print "data loaded"
metadata.close()
abundances.close()

header = abun[0]
abun = abun[1:]
header = header[1:]
#header = map(lambda x: x.split('_')[0], header)
header = map(lambda x: "before" if x in before else x, header)
header = map(lambda x: "after" if x in after else x, header)
print header
header = ["GENE"]+header
output_arr = []
count = 0
for gene in abun:
    zipped_gene = zip(header,gene)
    before_arr = filter(lambda z:z!="",map(lambda y: y[1], filter(lambda x: x[0] == "before",zipped_gene)))
    after_arr = filter(lambda z:z!="",map(lambda y: y[1], filter(lambda x: x[0] == "after",zipped_gene)))
    lba = len(before_arr)
    laa = len(after_arr)
    if len(before_arr) > 0:
        if len(after_arr) > 0:
            output_arr.append((str(stats.f_oneway(after_arr,before_arr)[1]),gene[0]))
    count += 1
    if count % 1000 == 0:
        print count
output_arr.sort()
ofile = open(sys.argv[3],'w')
for line in output_arr:
    ofile.write(line[1]+','+line[0]+'\n')
ofile.close()
