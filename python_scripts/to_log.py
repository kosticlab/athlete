import sys
import math
f = open(sys.argv[1],'r')
arr = []
for elem in f:
  arr.append(elem.rstrip().split(','))
arr2 = []
arr2.append(arr[0])
for elem in arr[1:]:
  gene = elem[0]
  work = elem[1:]
  work2 = map(lambda x: 0.0000000001 if x == '0.0' else x,work)
  print work2
  transformed = map(lambda x: math.log(float(x)),work2)
  arr2.append([gene]+transformed)
f.close()
off = open(sys.argv[2],'w')
for elem in arr2:
    off.write(",".join(map(lambda x: str(x),elem))+'\n')
off.close()
