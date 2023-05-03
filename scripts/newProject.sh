#!/bin/bash

folders=(
    data
        data/external
        data/interim
        data/processed
        data/raw
    docs
    models
    notebooks
    references
    reports
    src
    src/data
    src/features
    src/models
    src/visualization
)

mkdir "$1"
for i in "${folders[@]}"; do
    mkdir "$1/$i"
done

touch README.md

tree >> README.md
