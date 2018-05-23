from __future__ import division
import sys

cag_fh = open(sys.argv[1],'r')
genes_fh = open(sys.argv[2],'r')
cags_dict = {}
for line in cag_fh:
    sl = line.rstrip().split('\t')
    cag = sl[0]
    gene = sl[1]
    if cags_dict.has_key(cag):
        gene_set = cags_dict[cag]
        gene_set.add(gene)
        cags_dict[cag] = gene_set
    else:
        gene_set = set()
        gene_set.add(gene)
        cags_dict[cag] = gene_set
cags = {}
for lines in genes_fh:
    gene = lines.rstrip()
    for key in cags_dict.keys():
        if gene in cags_dict[key]:
            if cags.has_key(key):
                numt = cags[key]
                numt = numt + 1
                cags[key] = numt
            else:
                cags[key] = 1
print cags.keys()
#output = map(lambda x: (str(cags[x]/len(cags_dict[x])),cags_dict[x],x), cags.keys())
output.sort()
for elem in output:
    print elem
                #cag_size = len(cags_dict[key])
            #if cag_size >= 700:
             #   cags.append((key,cag_size))
    #prettyprint = map(lambda x: x[0]+':'+str(x[1]),cags)
    #print lines+','+','.join(prettyprint)

cag_fh.close()
genes_fh.close()
