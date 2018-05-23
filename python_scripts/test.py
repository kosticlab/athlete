from __future__ import division
import sys

def calc_abundance(sublist):
	gene = sublist[0]
	gene_length = float(sublist[1])
	values = sublist[2:]
	abundances = map(lambda x: x/gene_length, map(lambda y: float(y),values))
	return [gene]+abundances

f = open(sys.argv[1],'r')
raw_counts = []
for elem in f:
        raw_counts.append(elem.rstrip().replace(',,',',0,').split(','))
f.close()
print "loaded"


normalized_by_length = map(calc_abundance,raw_counts[1:])
print normalized_by_length
by_row = len(normalized_by_length)-1
by_col = len(normalized_by_length[0])
for x in range(1,by_col):
    numerics = []
    for y in range(0,by_row):
        numerics.append(normalized_by_length[y][x])
    sum_sublist = sum(numerics)
    for y in range(0,by_row):
        if sum_sublist == 0:
            normalized_by_length[y][x] = 0
        else:
            normalized_by_length[y][x] = numerics[y]/sum_sublist

output_file = open("relative_abundances.csv",'w')
header_line = [raw_counts[0][0]]+raw_counts[0][2:]
output_file.write(",".join(header_line)+'\n')
for line in normalized_by_length:
    print line
    output_file.write(",".join(map(lambda x:str(x),line))+'\n')
output_file.close()
