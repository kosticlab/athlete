import sys
vgenesf = open("veil_sigs.csv",'r')
vgenes = set()
for line in vgenesf:
    for elem in line.rstrip().split(',')[1:]:
        vgenes.add(elem)
inputf = open(sys.argv[1],'r')
arr = []
for lines in inputf:
    arr.append(lines.rstrip())
print arr[0]
for elem in arr[1:]:
    if elem.split(',')[0].split('_')[0] in vgenes:
        print elem
