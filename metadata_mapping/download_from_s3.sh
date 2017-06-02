#!/bin/bash

#get list of samples that the pipeline succesfully completed:
aws s3 ls s3://kosticlab-athlete/assemblies/ | sed 's/.*PRE //g' | sed 's/\///g' >> assemblies.txt
