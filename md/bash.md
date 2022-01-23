`declare -a var        `   Define an array var
`arr=(a b c)           `   Define an array
`arr[0]                `   Define an array item
`declare -A var        `   Define an table var (dictionary)
`dict=(["k"]="v")      `   Define an dictionary with values
`${array[0]}           `   Access an array item
`${arr[*]}             `   All of the items in the array
`${!arr[*]} ${!arr[@]} `   List indexes in the array
`${!pref*} ${!pref@}   `   List variables started with "pref"
`${#arr[*]}            `   Number of items in the array
`${#arr[0]}            `   Length of item zero
`${VAR:start:end}      `   Substring of $VAR
`${VAR/match/sub}      `   Replace matched value from $VAR
`${VAR=newvalue}       `   Set $VAR to "newvalue" if $VAR is not set
`${VAR:=newvalue}      `   Set $VAR to "newvalue" if $VAR is not set or empty
`${VAR#*.}             `   Left edge replace until first dot
`${VAR##*.}            `   Left edge replace until last dot
`${VAR%.*}             `   Right edge replace after last dot
`${VAR%%.*}            `   Right edge replace after first dot
`${VAR-default}        `   String "default" if $VAR is not set
`${VAR:-default}       `   String "default" if $VAR is not set or empty
`${VAR+other}          `   String "other" if $VAR is set, empty or not
`${VAR:+other}         `   String "other" if $VAR is set and not empty
`${VAR?error}          `   Exit 1 with "error" message if $VAR not set
`${VAR:?error}         `   Exit 1 with "error" message if $VAR not set or empty
`${VAR^pattern}        `   Uppercase matched pattern
`${VAR^^pattern}       `   Uppercase matched pattern all occurences
`${VAR,pattern}        `   Lowercase matched pattern
`${VAR,,pattern}       `   Lowercase matched pattern all occurences
`$(( expr ))           `   Arithmetic expansion. Calculate expr.
`a{d,c,b}e             `   Brace expansion returns "ade ace abe"
`pushd                 `   CD to a dir and add to dirstack



