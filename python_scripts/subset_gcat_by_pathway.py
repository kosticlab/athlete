import sys

#arg1 is input file, arg2 is search term

arr = []
inputf = open(sys.argv[1],'r')
for lines in inputf:
    arr.append(lines.rstrip())
inputf.close()
outputf = open("subset_gcat_"+sys.argv[2],'w')

append_flag = False
for x in arr:
    if x[0] == '>':
        if sys.argv[2] in x:
            outputf.write(x+'\n')

outputf.close()
