#!/bin/bash

#arg 1 is input file, args are 1-5 numbs from ec id
cat ${1} | grep "${2}\.${3}\.${4}\.${5}$" | cut -d'	' -f1 > ${2}.${3}.${4}.${5}.genes
python /Users/jacobluber/Desktop/athlete_metadata/github_code/subset_ramatrix_by_ecgenes.py ${2}.${3}.${4}.${5}.genes /Users/jacobluber/Desktop/athlete_metadata/relative_abundances.csv
Rscript /Users/jacobluber/Desktop/athlete_metadata/github_code/metadata_merger.R ${2}.${3}.${4}.${5}.genes_ramatrix
Rscript /Users/jacobluber/Desktop/athlete_metadata/github_code/plotting_stories_pathway.R ${2}.${3}.${4}.${5}.genes_ramatrix_mgx ${2}.${3}.${4}.${5}.genes_ramatrix_mtx
