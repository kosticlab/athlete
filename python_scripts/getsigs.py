import sys

inputf = open(sys.argv[1],'r')
arr = []
for lines in inputf:
    arr.append(lines.rstrip())
inputf.close()
outputf = open(sys.argv[2],'w')
newarr = []
cutoff = float(sys.argv[3])
for elem in arr:
    melem = elem.split(',')[1]
    if melem != "NA":
        if melem != "":
            if float(melem) < cutoff:
                newarr.append(elem)
for elem in newarr:
    outputf.write(elem+'\n')
outputf.close()

