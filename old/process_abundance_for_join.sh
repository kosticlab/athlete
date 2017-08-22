#!/bin/bash
#1:input 2:output 3:search

head -1 $1 > $2
grep $3 $1 | sed 's/_'${3}'//g' >> $2

