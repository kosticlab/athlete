#!/bin/bash
cat all.tsv | grep "\." | cut -d'    ' -f1,3,4 | sed 's/     [A-Za-z]*_[0-9]*//g' | sed 's/  [0-9]*[\.]*[\^a-zA-Z][a-zA-Z]*//g' | cut -d'    ' -f1,2 | cut -d' ' -f1 | sed 's/-[a-zA-Z].*//g' > gene_to_ec
