#!/bin/bash
myvar='dl.txt'
counter=0
total=$(sed -n '$=' $myvar)


while IFS=, read -r entry; do
    let counter++
    echo "Downloading [$counter/$total]"
    wget --quiet "$entry"
done < $myvar

printf "Files Downloaded: $total\n"
