import sys

inputf = sys.argv[1]
outputf = sys.argv[2]

f = open(inputf,'r')
o = open(outputf,'w')
arr = []
for elem in f:
    arr.append(elem.rstrip().split(','))

arrt = map(list, zip(*arr))

for elem in arrt:
    print elem[0]
    o.write(','.join(elem)+'\n')


o.close()
f.close()
