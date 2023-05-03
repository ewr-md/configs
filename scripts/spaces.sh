#!/bin/bash

counter=0
printf "Starting process.\n"
for oldF in *; do
    let counter++
    newF=$(echo "$oldF" | sed -e 's/\s/_/g' -e 's/[A-Z]/\L&/g' -e 's/-\+/-/g')
    mv -- "$oldF" "$newF"
done
printf "Files Modified: $counter.\n"
