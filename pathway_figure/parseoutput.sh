#!/bin/bash
find . -type f -name "*.gff" > files
for x in $(cat files);do cat ${x} >> ~/Desktop/preoutput; done
parallel -j8 --pipe --block 2M grep "eC" >> output < preoutput
cat output | sed 's/.*ID=//g' | sed 's/;.*//g' > genes
cat output | sed 's/.*eC_number=//g' | sed 's/;.*//g' > ecnumbers
paste -d, ecnumbers genes > db
cat db | grep -v "gene" > ec.db
rm ecnumbers genes preoutput output db
