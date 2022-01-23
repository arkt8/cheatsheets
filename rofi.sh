#!/bin/bash
docpath=$(realpath $(dirname $0)/md)
if [ -z "$@" ] ; then
	cd $docpath
	fdfind . -t f
else
	x-terminal-emulator -e bat --decorations never \
	--theme ansi-dark \
	--paging always \
	--pager "less -RXI" \
	"${docpath}/$*"
fi
