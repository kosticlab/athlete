import sys

#inputf #outputf

inputf = open(sys.argv[1],'r')
arr = []
for lines in inputf:
    arr.append(lines.rstrip())
inputf.close()

annots = set()
outputf = open(sys.argv[2],'w')
for lines in arr:
    if lines[0] == '>':
        annots.add(lines.split(' ')[1])

for elem in list(annots):
    outputf.write(elem+'\n')

outputf.close()
