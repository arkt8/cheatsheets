# List Comprehension

	listvar = [ itervar for itervar in [list] ]
	listvar = [ itervar for itervar in [list] if COND ]

Example:

	odd = [ i for i in range(0,20) if i % 2 != 0 ]



# Set Comprehension (unordered collection of uniques)

	setvar = { itervar for itervar in setvar }
	setvar = { itervar for itervar in setvar if COND }

Example:

	odd = { i for i in range(0,20) if i % 2 != 0 }



# Dictionary Comprehension

	dictvar = { kvar:vvar for k, v in dict.items() }
	dictvar = { kvar:vvar for k, v in dict.items() if COND }

Example:

	letters = {"a":1, "b":2, "c":3, "d":4}
	odd = {
		k.upper(): 'pos '+ str(v)
		for k, v in letters.items()
		if v % 2 != 0
	}

# Generator expression

	listiter = ( itervar for itervar in [list] )

Example:

	odditer = ( i for i in range(0,4) if i % 2 != 0 )
	print( next( odditer ) ) # 1
	print( next( odditer ) ) # 3
	print( next( odditer ) ) # Traceback... StopIteration

