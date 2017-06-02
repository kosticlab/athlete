import sys

#takes metadatafile, assemblies list, and output file and generates csv with all possible mappings

metadata = sys.argv[1]
assemblies = sys.argv[2]
output_file = sys.argv[3]

meta_arr = []
assem_arr = []

mfh = open(metadata,'r')
afh = open(assemblies,'r')

for line in mfh:
    meta_arr.append(line.rstrip().split('\t')[0])
mfh.close()

for line in afh:
    assem_arr.append(line.rstrip().split('\t')[0])
afh.close()

output_dict = {}
for elem in meta_arr:
    for sample in assem_arr:
        if elem in sample:
            if output_dict.has_key(elem):
                output_dict[elem].append(sample)
            else:
                output_dict[elem] = []
                output_dict[elem].append(sample)

ofh = open(output_file,'w')
for key in output_dict.keys():
    ofh.write("key:"+key+','+','.join(output_dict[key])+'\n')
ofh.close()
