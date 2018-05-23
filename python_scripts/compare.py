import sys

a = set()
f = open(sys.argv[1],'r')
for elem in f:
  a.add(elem.rstrip())
f.close()
f = open(sys.argv[2],'r')
b = set()
for elem in f:
  work = elem.rstrip().split(',')
  if work[1][0] != 'N':
    if float(work[1]) < .05:
        b.add(work[0])
print len(a)
print len(a-b)

