import sys
#in file #o indexed col #append string #output
infile = open(sys.argv[1],'r')
index = int(sys.argv[2])
append_str = sys.argv[3]
ofile = open(sys.argv[4],'w')
data_arr = []
for elem in infile:
    data_arr.append(elem.rstrip().split('\t'))
infile.close()
new_data_arr = []
darr2 = data_arr[1:]
for elem in darr2:
    elem[index] = elem[index]+append_str
    new_data_arr.append(elem)
ofile.write('\t'.join(data_arr[0])+'\n')
for elem in new_data_arr:
    ofile.write('\t'.join(elem)+'\n')
ofile.close()


