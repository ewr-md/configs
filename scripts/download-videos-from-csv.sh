#!/bin/bash
myvar='dl.csv'

#awk -F, '$1' $myvar

while IFS=, read -r entry; do
    youtube-dl "$entry";
done < $myvar
