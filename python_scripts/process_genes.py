import sys

genes_arr = set()
genes = open(sys.argv[1],'r')
for lines in genes:
    genes_arr.add(lines.rstrip())
genes.close()
abun_file = open(sys.argv[2],'r')
out_file = open(sys.argv[3],'w')
for lines in abun_file:
    if lines.split(',')[0] in genes_arr:
        out_file.write(lines)
abun_file.close()
out_file.close()
