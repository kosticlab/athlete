import sys

#metadata #mappingkey #outputf
metadata_f = open(sys.argv[1],'r')
mappingkey_f = open(sys.argv[2],'r')
mappings = {}
for elem in mappingkey_f:
    key_value = elem.rstrip().split('\t')
    mappings[key_value[0]] = key_value[1]
mappingkey_f.close()
data_arr = []
for elem in metadata_f:
    data_arr.append(elem.rstrip().split('\t'))
metadata_f.close()
converted_data_arr = []
for elem in data_arr[1:]:
    if mappings.has_key(elem[0]):
        elem[0] = mappings[elem[0]]+"_rutx"
        converted_data_arr.append(elem)
output_f = open(sys.argv[3],'w')
output_f.write('\t'.join(data_arr[0])+'\n')
for elem in converted_data_arr:
    output_f.write('\t'.join(elem)+'\n')
output_f.close()

