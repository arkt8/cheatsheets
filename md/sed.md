# Basic

* Replace                      ` sed 's/old/new/g' file.txt `
* Change file in place         ` sed 's/old/new/g' -i file.txt `
* Change file w/ backup        ` sed 's/old/new/g' -i.backup file.txt `
* From script                  ` sed -f script.sed file.txt `
* CLI multiple commands        ` sed -e 's/old/new/g' -e '/hello/d' file.txt `


# Replacing text

* all occurances               ` sed 's/old/new/g' file.txt `
* only 2nd occurance           ` sed 's/old/new/ 2' file.txt `
* only at line 5               ` sed '5 s/old/new/' file.txt `
* remove matched               ` sed 's/matched//' `

* "W" with "U” only if line start with "hello"
  ` sed ‘/hello/s/W/U/’ file.txt `


# Search for text

* Filter matched lines         ` sed -n '/hello/p' file.txt `
* Filter insensitive           ` sed -n '/hello/Ip' file.txt `
* Filter lines inverted        ` sed -n '/hello/!p' file.txt `


# Appending lines

* Append after line 2          ` sed '2a Text after line 2' file.txt `
* Append at end of file        ` sed '$a at eof' file.txt `
* Every 3rd line 3rd           ` sed '3~3a Some text' file.txt `


# Prepending lines

Prepending "helloworld" :
* Before line 5                ` sed '5i hello world' file.txt `
* before each line matched     ` sed '/matched/i helloworld’ file.txt`


# Deleting

* Deleting lines               ` 5,7d file.txt `
* Every 2nd line after 3.      ` sed '3~2d' file.txt `
* Last line in file            ` sed '$d' file.txt `
* Lines started with “Hello”.  ` sed '/^Hello/d' file.txt `
* Empty lines.                 ` sed '/^$/d' file.txt `
* Lines starting with “#”      ` sed '/^#/d' file.txt `
