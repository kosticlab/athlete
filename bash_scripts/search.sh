#!/bin/bash
grep "$1," ec.db >> $2
for x in $(cat $2);do grep $(echo ${x} | cut -d, -f2) filtered_anova_output > $2.vs;done
for x in $(cat $2);do grep $(echo ${x} | cut -d, -f2) significant_genes > $2.s;done
cat $2.vs | wc -l
cat $2.s | wc -l
