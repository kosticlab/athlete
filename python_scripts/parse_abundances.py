import sys
import os
def process_line(line):
    return line.split('>')[1].split('.')[0]

f = open(sys.argv[1],'r')
arr = set()
for lines in f:
    if "hypothetical" not in lines:
        arr.add(lines.split(' ')[0][1:])
f.close()
f = open(sys.argv[4],'r')
genes = set()
temparr = []
for line in f:
    if line[0] == '>':
        genesc = map(lambda x: process_line(x),temparr)
        if len(genesc) > 1:
            for elem in genesc:
                genes.add(elem)
        temparr = []
    else:
        temparr.append(line)
f.close()
f = open(sys.argv[2],'r')
os.system("head -1 ru2.csv > "+sys.argv[3])
off = open(sys.argv[3],'a')
for line in f:
    gene = line.split(',')[0]
    if gene in arr:
        if gene in genes:
            off.write(line)
f.close()
off.close()
