import sys

gene_set = set()
inputf = open(sys.argv[1],'r')
for line in inputf:
    gene = line.rstrip().split('\t')[1]
    gene_set.add(gene)

inputf.close()
outf = open(sys.argv[2],'w')
for gene in gene_set:
    outf.write(gene+'\n')
outf.close()
#parallel --gnu -a vgenes.txt -P 8 ./search
