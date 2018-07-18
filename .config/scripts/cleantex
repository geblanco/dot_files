#!/bin/bash

dir=$(pwd)
if [[ $# -gt 0 ]]; then
  dir=$1
fi

cd $dir
aux=(*.aux *.lof *.log *.lot *.fls *.out *.toc *.fmt *.fot *.cb *.cb2 *.synctex.gz *.bbl *.blg  *.dvi  *.fdb_latexmk)
for file in ${aux[@]}; do
  if [[ -f $file ]]; then
    echo "- Remove $file"
    rm $file
  fi
done

cd -
