import sys

cag_fh = open(sys.argv[1],'r')
genes_fh = open(sys.argv[2],'r')
ofh = open(sys.argv[3],'a')
cags_genes = set()
for line in cag_fh:
    gene = line.rstrip()
    cags_genes.add(gene)
for lines in genes_fh:
    if lines.split(',')[0] in cags_genes:
        ofh.write(lines)

cag_fh.close()
genes_fh.close()
ofh.close()
