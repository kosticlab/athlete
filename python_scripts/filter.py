import os

outputf = open('criteria_abundances001.csv','w')
with open('relative_abundances.csv') as fp:
    count = 0
    for line in fp:
        if count == 0:
            outputf.write(line)
            count+=1
        else:
            t=map(lambda x: float(x),line.rstrip().split(',')[1:])
            if abs(min(t)-max(t)) > 0.001:
                outputf.write(line)
            if count % 10000 == 0:
                print count
            count += 1

fp.close()
outputf.close()


