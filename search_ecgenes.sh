#!/bin/bash

#arg 1 is input file, args are 1-5 numbs from ec id
cat ${1} | grep "${2}\.${3}\.${4}\.${5}$" | cut -d'	' -f1 > ${2}.${3}.${4}.${5}.genes

