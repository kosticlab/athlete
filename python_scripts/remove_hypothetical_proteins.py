import sys

#arg1 is input file, arg2 is outputfile

arr = []
inputf = open(sys.argv[1],'r')
for lines in inputf:
    arr.append(lines.rstrip())
inputf.close()
outputf = open(sys.argv[2],'w')

append_flag = False
for x in arr:
    if x[0] == '>':
        if x.split(' ')[1] != "hypothetical":
            append_flag = True
        else:
            append_flag = False
    if append_flag == True:
        outputf.write(x+'\n')

outputf.close()
