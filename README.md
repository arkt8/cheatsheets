# Cheatsheets

Put your files inside md folder in markdown format.
It doesn't need be formatted as if should be printed in HTML as you may
prefer that be clean and easy to eyes in a terminal.

Add `./run.sh` as your keybinding and optionally `./run edit` too

## How to create cheatsheets

You may prefer a well designed tree...

```
py/stdlib.md
py/requests.md
vim/verbs.md
awk/awk.md
```

This way all files are scoped inside an directory.

## Styling

Well, it is a markdown babe! As every good cheatsheet, be short, concise and mnemonic.
Put first on file the short reference. If it is complicated, you can add examples after.

As the file will be open using bat you can search on terminal with "/" when the file opens.

Golden rule: never exceeds 80 columns in your file. The readability is better
on limited line length.

Suggestion:

    name_of_function( param1=type, param2=type ) » return type
        Description of function
        * param1 description
        * param2 description

## Dependencies

* bat (batcat) an improved cat
* dmenu - fuzzy search

## Copyright

MIT, free as you will... but if you can wrote some
