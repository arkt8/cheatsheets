#!/bin/bash

color0='#000000'
color8='#000000'
color2='#222222'
color15='#ffffff'

. $HOME/.cache/wal/colors.sh


cd $( realpath $( dirname $0 ) )/md || exit

file="$(\
	find . -name '*md'\
	| sed 's/^\.\///g' \
	| rofi -dmenu -l 10 \
	)"

if [[ "$file" == "edit" ]]
	then x-terminal-emulator -e editor ./ ; exit; fi

if [[ -z "$file" ]]
	then exit; fi

 [[ -n $TERM ]] \
 && x-terminal-emulator -e bat --decorations never \
 	--theme ansi-dark \
 	--paging always \
 	"$file"
