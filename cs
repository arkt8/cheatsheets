#!/bin/bash

localpath="$(dirname "$(realpath "$0")")"
cd "$localpath/md"
FZF="fzf \
    --color=16 \
    --border=rounded \
    --keep-right \
    --layout=reverse-list \
    --bind 'ctrl-e:execute(vim {})'"
FZF="fzf --bind ctrl\-e:execute\(nvim \{\}\)"

find . -type f |sort | sed "s/\.\///g" | \
  fzf \
    --color=16 \
    --border=rounded \
    --keep-right \
    --layout=reverse-list \
    --preview-window="right,80%,border-left" \
    --bind 'ctrl-e:execute(vim {})' \
    --preview="bat --plain --paging=always {1} --color=always"
