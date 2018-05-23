import os
import sys
from scipy import stats

before = set()
after = set()

genes = open(sys.argv[3],'r')
gr = []
for lines in genes:
    gr.append(lines.rstrip().split(',')[0])
genes.close()
meta = []
metadata = open(sys.argv[1],'r')
for lines in metadata:
    meta.append(lines.rstrip().split('\t'))
meta = meta[1:]
for elem in meta:
    if elem[12] == "Elite":
            before.add(elem[0])
    if elem[12] == "Everyday":
            after.add(elem[0])

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
header = map(lambda x: x.split('_')[0], header)
header = map(lambda x: "before" if x in before else x, header)
header = map(lambda x: "after" if x in after else x, header)
header = ["GENE"]+header
output_arr = []
output_arr.append(("condition","ra"))
for gene in abun:
    if gene[0] in gr:
        zipped_gene = zip(header,gene)
        elite_arr = map(lambda y: y[1], filter(lambda x: x[0] == "before",zipped_gene))
        everyday_arr = map(lambda y: y[1], filter(lambda x: x[0] == "after",zipped_gene))
        for elem in elite_arr:
            output_arr.append(("before",str(elem)))
        for elem in everyday_arr:
            output_arr.append(("after",str(elem)))
outputf = open(sys.argv[4],'w')
for elem in output_arr:
    outputf.write(",".join(elem)+'\n')
outputf.close()
