# Variables

`arg`      - arguments passed on script call from CLI
`_G`       - The global variable
`_VERSION` - Lua version


# Misc


`collectgarbage ( [opt=string [, arg=number ] ] )`

* `opt` Can be one of these strings
    - "collect"      full collection cycle (default)
    - "stop"         stops gc auto execution
    - "restart"      restarts gc auto execution
    - "count"        report total KiB and KB mem used by Lua 
    - "step"         performs a collection step.
    - "setpause"     sets `arg` as value for the pause gc
    - "setstepmul"   sets `arg` as step multiplier of gc
    - "isrunning"    returns a boolean
    - "generational" puts gc in generational mode.
    - "incremental"  puts gc in incremental mode. (default)


`assert ( v=boolean [, message=string])`

* `v` : expression evalued to boolean
* `msg` : message to be show case v evaluates as false


`error (message [, level])`
Raises error

* `level` a number with one of these:
    - 1 traces error to where `error()` was called
    - 2 traces error to the call of the `error()` caller
    - 0 omit the error position


# Debug


# Type handling


`type (v) » string`
Returns the type of its only argument, coded as a string.


`print (···)`
Prints to stdout its received arguments


`tonumber (e [, base = number]) » number | nil `


* `e` - value to be converted to number
* `base` - any integer between 2 and 36
Returns numer or nil if `e` cannot be converted


`tostring (v) » string`
Converts any `v` to string, and if there is `v.__tostring`, calls it


# Importing code


`dofile ( [ filename=string ] ) `
Execute Lua chunk from file and returns the chunk returned value
If no filename, then read from stdin


`load (chunk [, src [, mode [, env]]]) » fn | nil, string `
Loads a function as a chunk of Lua code
returns a function in success or nil with error message
* `chunk`
    - if string, the chunk is this string.
    - if function, calls it repeatedly to get the chunks
* `src` name to be used on trace
* `mode`   `b`|`t`|`bt` (binary / text, defaults `bt`)
* `env`    specify table used as environment instead upvalues


`loadfile ([filename [, mode [, env]]])`
Same as `load()` but from a file


`pcall (f [, arg, ···]) » boolean, mixed`
Call function `f` with given arguments in protected mode.
In success returns `true` followed for all returns
In error returns `false`, followed of the error message.


`xpcall (f, msg_handler [, arg1, ···])`
Similar to `pcall()`, but `msg_handler` is a function that
receve the error message as argument to decide what to do.


# Tables


`getmetatable (t)`


`ipairs (t) » f(), table, number`
Returns a function that returns index and value.
It stops at first nil value found, so
`{ 'a', 'b', 'nil', 'c'}` will stop at `b`


`pairs (t) » f(), table, nil or key`
Calls `t.__pairs(t)` and returns first three results or
returns a function, the table and the key or nil.

* `t` a table


`next (table [, key]) » key, value`

* `key` inform current position on table, if nil, get first

Ex: `next(t)` can be used to check if a table is empty


# Metatables


`rawequal (v1, v2) » boolean`
Check if `v1` is metamethod. Returns a boolean


`rawget (table, index) » mixed`
Real value of `table[index]`, without invoking metamethod


`rawlen (obj) » number`
Length of `obj` (a table or a string), without invoking metamethod


`rawset (table, index, v) » table`
Sets real value of `table[index]` to `v`, without invoking any metamethod.

`setmetatable (t [, mt]) » table`
Sets the `mt` as metatable for table `t`
or raises error if one already set.
Removes it if `mt` is nil.

# Metamethods

`metatable.__ipairs`, called with table as argument on ipairs()

# Mathematical Functions

`math.acos (x) » number`     Returns the arc cosine of `x`radians

`math.asin (x) » number`     Returns the arc sine of `x` radians

`math.atan (x) » number`     Returns the arc tangent of `x` radians

`math.atan2 (y, x) » number` The arc tangent of `y`/`x` radians

`math.cos (x) » number`      Returns the cosine of `x` radians

`math.cosh (x) » number`     Returns the hyperbolic cosine of x

`math.tan (x) » number`      Returns the tangent of `x` radians

`math.tanh (x) » number`     Returns the hyperbolic tangent of `x`.

`math.sin (x) » number`      Returns the sin of `x` radians

`math.sinh (x) » number`     Returns the hyperbolic sin of `x`.

`math.deg (x) » number`      Give the radian angle of `x` in degrees

`math.abs (x)` Returns the absolute value of `x`

`math.exp (x) » number` Returns the value ex.

`math.sqrt (x) » number` Returns the square root of `x`

`math.floor (x) » number` Round down `x` value

`math.ceil (x) » number` Round up `x` value

`math.frexp (x) » number m, number e`
Returns `m` and `e` such that `x = m * (2^e)`
Where `e` is an integer and m is 0 when `x=0` or between 0.5 and 1

`math.huge` Return value HUGE_VAL, usually inf

`math.ldexp (m, e)` Returns m2e (e should be an integer).

`math.log (x [, base])`
Returns the log of `x` in the given `base`.
Default base is "e" (natural)

`math.max (n1, n2, ···)` Maximum value among its arguments

`math.min (n1, n2, ···)` Minimum value among its arguments

`math.modf (x) » number, number`
integral and fractional parts of `x`
Example: `math.modf(4.3)` returns 4 and 0.3

`math.fmod (x, y) » number`
Remainder of division of `x` by `y`
Same as `x % y`

`math.pi` The value of "π" (pi constant)

`math.pow (x, y)` Power of `x` to `y` same as `x^y`

`math.rad (x) » number` Returns the `x` degrees in radians.

`math.random ([m [, n]]) » number` Pseudo random number generator

`math.randomseed (x)`
Sets `x` as the "seed" for the pseudo-random generator.


# String Patterns

* `.`  (a dot) represents all characters.
* `%a` letters.
* `%c` control characters.
* `%d` digits.
* `%g` printable characters except space.
* `%l` lowercase letters.
* `%p` punctuation characters.
* `%s` space characters.
* `%u` uppercase letters.
* `%w` alphanumeric characters.
* `%x` hexadecimal digits.
* `%%` % escaped
* `[set]`: matches a set ex: `[%a%s]`
* `[^set]`: matches what is not in the set
* `%A, %C, %D ···` matches the complement of lowercase ones
* `^` at start maches only if pattern is at the beginning of string
* `^` at end maches only if pattern is at the end of string
* `*` zero or more (longest possible)
* `-` zero or more (shortest possible)
* `+` one or more occurrences
* `?` zero or one occurrence
* `(···)`   capture the string matched inside parentheses
* `()`      empty parentheses resolves for the position number
* `%1···%9` references to captures

<!--
vim: ts=4 sts=4 sw=4 expandtab
-->
