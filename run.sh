#!/bin/bash
cd $( realpath $( dirname $0 ) )/md || exit

if [[ "$1" == "edit" ]] ; then x-terminal-emulator -e editor ./ ; exit; fi
file=$(find . -name '*md' | sed 's/^\.\///g' \
  | dmenu -b -i -l 10 \
          -fn 'VictorMono:pixelsize=16' \
          -sf '#99d1ce'  -sb '#195466' \
          -nb '#0a0f14'  -nf '#33859e')

if [[ -z "$file" ]] ; then exit; fi

alacritty -e bat  --paging always --pager "less -RXI" "$file"
