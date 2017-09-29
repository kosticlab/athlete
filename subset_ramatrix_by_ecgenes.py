import sys
import os
#pathway genes file from subsetting gene catalog #relative abundance matrix

pgenes_fh = open(sys.argv[1],'r')
pgenes = set()
for elem in pgenes_fh:
    pgenes.add(elem.rstrip())
pgenes_fh.close()


os.system("head -1 "+sys.argv[2]+" > "+sys.argv[1]+"_ramatrix")
output_fh = open(sys.argv[1]+"_ramatrix",'a')

ram_matrix_fh = open(sys.argv[2],'r')
ram_matrix = []
for elem in ram_matrix_fh:
    curr_gene = elem.rstrip().split(',')[0]
    if curr_gene in pgenes:
        output_fh.write(elem)

output_fh.close()
ram_matrix_fh.close()

