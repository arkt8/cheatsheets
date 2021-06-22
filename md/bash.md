declare -a var			Define an array var
arr=(a b c)				Define an array
arr[0]					Define an array item
declare -A var			Define an table var (dictionary)
dict=(["k"]="v")		Define an dictionary with values
${array[0]}				Access an array item :parexp:
${arr[*]}				All of the items in the array :parexp:
${!arr[*]} ${!arr[@]}	List indexes in the array :parexp:
${!pref*} ${!pref@}		List variables with name prefixed with "pref" :parexp-variables:
${#arr[*]}				Number of items in the array :parexp:
${#arr[0]}				Length of item zero :parexp:
${VAR:start:end}		Substring of $VAR :parexp:
${VAR/match/sub}		Replace matched value from $VAR :parexp-pattern:
${VAR=newvalue}			Set $VAR to "newvalue" if $VAR is not set :parexp-pattern:
${VAR:=newvalue}		Set $VAR to "newvalue" if $VAR is not set or empty :parexp:
${VAR#*.}				Left edge replace until first dot :parexp-pattern:
${VAR##*.}				Left edge replace until last dot :parexp-pattern:
${VAR%.*}				Right edge replace after last dot :parexp-pattern:
${VAR%%.*}				Right edge replace after first dot :parexp-pattern:
${VAR-default}			String "default" if $VAR is not set :parexp-conditional:
${VAR:-default}			String "default" if $VAR is not set or empty :parexp-conditional:
${VAR+other}			String "other" if $VAR is set, empty or not :parexp-conditional:
${VAR:+other}			String "other" if $VAR is set and not empty :parexp-conditional:
${VAR?error}			Exit 1 with "error" message if $VAR not set :parexp-conditional:
${VAR:?error}			Exit 1 with "error" message if $VAR not set or empty :parexp-conditional:
${VAR^pattern}			Uppercase matched pattern :parexp:
${VAR^^pattern}			Uppercase matched pattern all occurences :parexp:
${VAR,pattern}			Lowercase matched pattern :parexp:
${VAR,,pattern}			Lowercase matched pattern all occurences :parexp:
$(( expr ))				Arithmetic expansion. Calculate expr.
a{d,c,b}e				Brace expansion returns "ade ace abe"
pushd					CD to a dir and add to dirstack :filesystem:



