#!/usr/bin/env bash

# Download data from the SraRuntable.txt file
grep -v Run SraRunTable.txt | cut -d ',' -f 1 | while IFS= read -r line; do
    fastq-dump "$line"
done