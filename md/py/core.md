# Dictionary

Creation    `x = { 'a': 'valueA', 'b': 'valueB' }`

Item get    `x.keys()`   returns ('a','b')
            `x.values()` returns ('valueA','valueB')
            `x.items()`  returns (('a','valueA'),('b','valueB'))

Item remove `x.pop('a')`
            `del x['a']`

Item add    `x['a'] = 'othervalueA'`

Item update `x.update( { 'b': 'othervalueB' } )`

Removal	    `del x`

**Example**

	for key,value in x.items() :
		print( key, value )
