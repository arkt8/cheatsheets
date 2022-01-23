`select (index, ...) » mixed, ...mixedN`
    If index is number, returns args after index;
    A negative number indexes from the end
    Otherwise, `index` must be the string "#" returning arg count
    Ex:

        function x(...) print( select('#',...) ) end
        function y(...) print( select(2,...) ) end
        x('a','b','c') -- prints 3`
        y('a','b','c') -- prints 'b' 'c'

# Coroutine Manipulation

The operations related to coroutines comprise a sub-library of the basic library and come inside the table coroutine. See §2.6 for a general description of coroutines.

`coroutine.create (func) » thread`
Creates a new coroutine

`coroutine.resume (thread [, val1, ···]) » mixed`
Starts or continues the execution of coroutine `thread`.
At first resume `val1, ···` are passed to body function.
Subsequent calls `val1, ···` are passed as yielded
After thread end, subsequent calls return `false` and a message.

`coroutine.running () » thread, boolean`
Returns the running coroutine plus a boolean status

`coroutine.status (thread)`
Returns the status of coroutine `thread`, as a string:
- "running", if the coroutine is running
- "suspended", if the coroutine is suspended in a call to yield, or isn't started yet
"normal" if the coroutine is active but not running (that is, it has resumed another coroutine); and "dead" if the coroutine has finished its body function, or if it has stopped with an error.

`coroutine.wrap (f)`

Creates a new coroutine, with body f. f must be a Lua function. Returns a function that resumes the coroutine each time it is called. Any arguments passed to the function behave as the extra arguments to resume. Returns the same values returned by resume, except the first boolean. In case of error, propagates the error.

`coroutine.yield (···)`

Suspends the execution of the calling coroutine. Any arguments to yield are passed as extra results to resume.

6.3 – Modules

The package library provides basic facilities for loading modules in Lua. It exports one function directly in the global environment: require. Everything else is exported in a table package.

`require (modname)`

Loads the given module. The function starts by looking into the package.loaded table to determine whether modname is already loaded. If it is, then require returns the value stored at package.loaded[modname]. Otherwise, it tries to find a loader for the module.

To find a loader, require is guided by the package.searchers sequence. By changing this sequence, we can change how require looks for a module. The following explanation is based on the default configuration for package.searchers.

First require queries package.preload[modname]. If it has a value, this value (which should be a function) is the loader. Otherwise require searches for a Lua loader using the path stored in package.path. If that also fails, it searches for a C loader using the path stored in package.cpath. If that also fails, it tries an all-in-one loader (see package.searchers).

Once a loader is found, require calls the loader with two arguments: modname and an extra value dependent on how it got the loader. (If the loader came from a file, this extra value is the file name.) If the loader returns any non-nil value, require assigns the returned value to package.loaded[modname]. If the loader does not return a non-nil value and has not assigned any value to package.loaded[modname], then require assigns true to this entry. In any case, require returns the final value of package.loaded[modname].

If there is any error loading or running the module, or if it cannot find any loader for the module, then require raises an error.

`package.config`

A string describing some compile-time configurations for packages. This string is a sequence of lines:

The first line is the directory separator string. Default is '\' for Windows and '/' for all other systems.
The second line is the character that separates templates in a path. Default is ';'.
The third line is the string that marks the substitution points in a template. Default is '?'.
The fourth line is a string that, in a path in Windows, is replaced by the executable's directory. Default is '!'.
The fifth line is a mark to ignore all text before it when building the luaopen_ function name. Default is '-'.
package.cpath

The path used by require to search for a C loader.

Lua initializes the C path package.cpath in the same way it initializes the Lua path package.path, using the environment variable LUA_CPATH_5_2 or the environment variable LUA_CPATH or a default path defined in luaconf.h.

`package.loaded`

A table used by require to control which modules are already loaded. When you require a module modname and package.loaded[modname] is not false, require simply returns the value stored there.

This variable is only a reference to the real table; assignments to this variable do not change the table used by require.

`package.loadlib (libname, funcname)`

Dynamically links the host program with the C library libname.

If funcname is "*", then it only links with the library, making the symbols exported by the library available to other dynamically linked libraries. Otherwise, it looks for a function funcname inside the library and returns this function as a C function. So, funcname must follow the lua_CFunction prototype (see lua_CFunction).

This is a low-level function. It completely bypasses the package and module system. Unlike require, it does not perform any path searching and does not automatically adds extensions. libname must be the complete file name of the C library, including if necessary a path and an extension. funcname must be the exact name exported by the C library (which may depend on the C compiler and linker used).

This function is not supported by Standard C. As such, it is only available on some platforms (Windows, Linux, Mac OS X, Solaris, BSD, plus other Unix systems that support the dlfcn standard).

`package.path`

The path used by require to search for a Lua loader.

At start-up, Lua initializes this variable with the value of the environment variable LUA_PATH_5_2 or the environment variable LUA_PATH or with a default path defined in luaconf.h, if those environment variables are not defined. Any ";;" in the value of the environment variable is replaced by the default path.

`package.preload`

A table to store loaders for specific modules (see require).

This variable is only a reference to the real table; assignments to this variable do not change the table used by require.

`package.searchers`

A table used by require to control how to load modules.

Each entry in this table is a searcher function. When looking for a module, require calls each of these searchers in ascending order, with the module name (the argument given to require) as its sole parameter. The function can return another function (the module loader) plus an extra value that will be passed to that loader, or a string explaining why it did not find that module (or nil if it has nothing to say).

Lua initializes this table with four searcher functions.

The first searcher simply looks for a loader in the package.preload table.

The second searcher looks for a loader as a Lua library, using the path stored at package.path. The search is done as described in function package.searchpath.

The third searcher looks for a loader as a C library, using the path given by the variable package.cpath. Again, the search is done as described in function package.searchpath. For instance, if the C path is the string

     "./?.so;./?.dll;/usr/local/?/init.so"
the searcher for module foo will try to open the files ./foo.so, ./foo.dll, and /usr/local/foo/init.so, in that order. Once it finds a C library, this searcher first uses a dynamic link facility to link the application with the library. Then it tries to find a C function inside the library to be used as the loader. The name of this C function is the string "luaopen_" concatenated with a copy of the module name where each dot is replaced by an underscore. Moreover, if the module name has a hyphen, its prefix up to (and including) the first hyphen is removed. For instance, if the module name is a.v1-b.c, the function name will be luaopen_b_c.

The fourth searcher tries an all-in-one loader. It searches the C path for a library for the root name of the given module. For instance, when requiring a.b.c, it will search for a C library for a. If found, it looks into it for an open function for the submodule; in our example, that would be luaopen_a_b_c. With this facility, a package can pack several C submodules into one single library, with each submodule keeping its original open function.

All searchers except the first one (preload) return as the extra value the file name where the module was found, as returned by package.searchpath. The first searcher returns no extra value.

`package.searchpath (name, path [, sep [, rep]])`

Searches for the given name in the given path.

A path is a string containing a sequence of templates separated by semicolons. For each template, the function replaces each interrogation mark (if any) in the template with a copy of name wherein all occurrences of sep (a dot, by default) were replaced by rep (the system's directory separator, by default), and then tries to open the resulting file name.

For instance, if the path is the string

     "./?.lua;./?.lc;/usr/local/?/init.lua"
the search for the name foo.a will try to open the files ./foo/a.lua, ./foo/a.lc, and /usr/local/foo/a/init.lua, in that order.

Returns the resulting name of the first file that it can open in read mode (after closing the file), or nil plus an error message if none succeeds. (This error message lists all file names it tried to open.)

6.4 – String Manipulation

This library provides generic functions for string manipulation, such as finding and extracting substrings, and pattern matching. When indexing a string in Lua, the first character is at position 1 (not at 0, as in C). Indices are allowed to be negative and are interpreted as indexing backwards, from the end of the string. Thus, the last character is at position -1, and so on.

The string library provides all its functions inside the table string. It also sets a metatable for strings where the `__index` field points to the string table. Therefore, you can use the string functions in object-oriented style. For instance, string.byte(s,i) can be written as s:byte(i).

The string library assumes one-byte character encodings.

`string.byte (s [, i [, j]])`

Returns the internal numerical codes of the characters s[i], s[i+1], ..., s[j]. The default value for i is 1; the default value for j is i. These indices are corrected following the same rules of function string.sub.
Numerical codes are not necessarily portable across platforms.

`string.char (···)`

Receives zero or more integers. Returns a string with length equal to the number of arguments, in which each character has the internal numerical code equal to its corresponding argument.
Numerical codes are not necessarily portable across platforms.

`string.dump (function)`

Returns a string containing a binary representation of the given function, so that a later load on this string returns a copy of the function (but with new upvalues).

`string.find (s, pattern [, init [, plain]])`

Looks for the first match of pattern in the string s. If it finds a match, then find returns the indices of s where this occurrence starts and ends; otherwise, it returns nil. A third, optional numerical argument init specifies where to start the search; its default value is 1 and can be negative. A value of true as a fourth, optional argument plain turns off the pattern matching facilities, so the function does a plain "find substring" operation, with no characters in pattern being considered magic. Note that if plain is given, then init must be given as well.

If the pattern has captures, then in a successful match the captured values are also returned, after the two indices.

`string.format (formatstring, ···)`

Returns a formatted version of its variable number of arguments following the description given in its first argument (which must be a string). The format string follows the same rules as the ISO C function sprintf. The only differences are that the options/modifiers `*`, `h`, `L`, `l`, `n`, and p are not supported and that there is an extra option, q. The q option formats a string between double quotes, using escape sequences when necessary to ensure that it can safely be read back by the Lua interpreter. For instance, the call

     string.format('%q', 'a string with "quotes" and \n new line')
may produce the string:

     "a string with \"quotes\" and \
      new line"
Options A and a (when available), E, e, f, G, and g all expect a number as argument. Options c, d, i, o, u, X, and x also expect a number, but the range of that number may be limited by the underlying C implementation. For options o, u, X, and x, the number cannot be negative. Option q expects a string; option s expects a string without embedded zeros. If the argument to option s is not a string, it is converted to one following the same rules of tostring.

string.gmatch (s, pattern)

Returns an iterator function that, each time it is called, returns the next captures from pattern over the string s. If pattern specifies no captures, then the whole match is produced in each call.
As an example, the following loop will iterate over all the words from string s, printing one per line:

     s = "hello world from Lua"
     for w in string.gmatch(s, "%a+") do
       print(w)
     end
The next example collects all pairs key=value from the given string into a table:

     t = {}
     s = "from=world, to=Lua"
     for k, v in string.gmatch(s, "(%w+)=(%w+)") do
       t[k] = v
     end
For this function, a caret '^' at the start of a pattern does not work as an anchor, as this would prevent the iteration.

`string.gsub (s, pattern, repl [, n])`

Returns a copy of s in which all (or the first n, if given) occurrences of the pattern have been replaced by a replacement string specified by repl, which can be a string, a table, or a function. gsub also returns, as its second value, the total number of matches that occurred. The name gsub comes from Global SUBstitution.
If repl is a string, then its value is used for replacement. The character % works as an escape character: any sequence in repl of the form %d, with d between 1 and 9, stands for the value of the d-th captured substring. The sequence %0 stands for the whole match. The sequence %% stands for a single %.

If repl is a table, then the table is queried for every match, using the first capture as the key.

If repl is a function, then this function is called every time a match occurs, with all captured substrings passed as arguments, in order.

In any case, if the pattern specifies no captures, then it behaves as if the whole pattern was inside a capture.

If the value returned by the table query or by the function call is a string or a number, then it is used as the replacement string; otherwise, if it is false or nil, then there is no replacement (that is, the original match is kept in the string).

Here are some examples:

     x = string.gsub("hello world", "(%w+)", "%1 %1")
     --> x="hello hello world world"
     
     x = string.gsub("hello world", "%w+", "%0 %0", 1)
     --> x="hello hello world"
     
     x = string.gsub("hello world from Lua", "(%w+)%s*(%w+)", "%2 %1")
     --> x="world hello Lua from"
     
     x = string.gsub("home = $HOME, user = $USER", "%$(%w+)", os.getenv)
     --> x="home = /home/roberto, user = roberto"
     
     x = string.gsub("4+5 = $return 4+5$", "%$(.-)%$", function (s)
           return load(s)()
         end)
     --> x="4+5 = 9"
     
     local t = {name="lua", version="5.2"}
     x = string.gsub("$name-$version.tar.gz", "%$(%w+)", t)
     --> x="lua-5.2.tar.gz"

`string.len (s)`

Receives a string and returns its length. The empty string "" has length 0. Embedded zeros are counted, so "a\000bc\000" has length 5.

`string.lower (s)`

Receives a string and returns a copy of this string with all uppercase letters changed to lowercase. All other characters are left unchanged. The definition of what an uppercase letter is depends on the current locale.
string.match (s, pattern [, init])

Looks for the first match of pattern in the string s. If it finds one, then match returns the captures from the pattern; otherwise it returns nil. If pattern specifies no captures, then the whole match is returned. A third, optional numerical argument init specifies where to start the search; its default value is 1 and can be negative.
string.rep (s, n [, sep])

Returns a string that is the concatenation of n copies of the string s separated by the string sep. The default value for sep is the empty string (that is, no separator).
string.reverse (s)

Returns a string that is the string s reversed.
string.sub (s, i [, j])

Returns the substring of s that starts at i and continues until j; i and j can be negative. If j is absent, then it is assumed to be equal to -1 (which is the same as the string length). In particular, the call string.sub(s,1,j) returns a prefix of s with length j, and string.sub(s, -i) returns a suffix of s with length i.
If, after the translation of negative indices, i is less than 1, it is corrected to 1. If j is greater than the string length, it is corrected to that length. If, after these corrections, i is greater than j, the function returns the empty string.

`string.upper (s)`

Receives a string and returns a copy of this string with all lowercase letters changed to uppercase. All other characters are left unchanged. The definition of what a lowercase letter is depends on the current locale.

6.5 – Table Manipulation

This library provides generic functions for table manipulation. It provides all its functions inside the table table.

Remember that, whenever an operation needs the length of a table, the table should be a proper sequence or have a `__len` metamethod (see §3.4.6). All functions ignore non-numeric keys in tables given as arguments.

For performance reasons, all table accesses (get/set) performed by these functions are raw.

`table.concat (list [, sep [, i [, j]]])`

Given a list where all elements are strings or numbers, returns the string list[i]..sep..list[i+1] ··· sep..list[j]. The default value for sep is the empty string, the default for i is 1, and the default for j is #list. If i is greater than j, returns the empty string.

`table.insert (list, [pos,] value)` insert at end of list or at `pos`
`table.pack (···)`

Returns a new table with all parameters stored into keys 1, 2, etc. and with a field "n" with the total number of parameters. Note that the resulting table may not be a sequence.

`table.remove (list [, pos])`

Removes from list the element at position pos, returning the value of the removed element. When pos is an integer between 1 and #list, it shifts down the elements list[pos+1], list[pos+2], ···, list[#list] and erases element list[#list]; The index pos can also be 0 when #list is 0, or #list + 1; in those cases, the function erases the element list[pos].

The default value for pos is #list, so that a call table.remove(t) removes the last element of list t.

`table.sort (list [, comp])`

Sorts list elements in a given order, in-place, from list[1] to list[#list]. If comp is given, then it must be a function that receives two list elements and returns true when the first element must come before the second in the final order (so that not comp(list[i+1],list[i]) will be true after the sort). If comp is not given, then the standard Lua operator `<` is used instead.

`table.unpack (list [, i [, j]])`

Returns the elements from the given table. This function is equivalent to

     return list[i], list[i+1], ···, list[j]
By default, i is 1 and j is #list.

6.7 – Bitwise Operations

This library provides bitwise operations. It provides all its functions inside the table bit32.

Unless otherwise stated, all functions accept numeric arguments in the range (-251,+251); each argument is normalized to the remainder of its division by 232 and truncated to an integer (in some unspecified way), so that its final value falls in the range [0,232 - 1]. Similarly, all results are in the range [0,232 - 1]. Note that bit32.bnot(0) is 0xFFFFFFFF, which is different from -1.

`bit32.arshift (x, disp)`

Returns the number x shifted disp bits to the right. The number disp may be any representable integer. Negative displacements shift to the left.

This shift operation is what is called arithmetic shift. Vacant bits on the left are filled with copies of the higher bit of x; vacant bits on the right are filled with zeros. In particular, displacements with absolute values higher than 31 result in zero or 0xFFFFFFFF (all original bits are shifted out).

`bit32.band (···)`

Returns the bitwise and of its operands.

`bit32.bnot (x)`

Returns the bitwise negation of x. For any integer x, the following identity holds:

     assert(bit32.bnot(x) == (-1 - x) % 2^32)
`bit32.bor (···)`

Returns the bitwise or of its operands.

`bit32.btest (···)`

Returns a boolean signaling whether the bitwise and of its operands is different from zero.

`bit32.bxor (···)`

Returns the bitwise exclusive or of its operands.

bit32.extract (n, field [, width])

Returns the unsigned number formed by the bits field to field + width - 1 from n. Bits are numbered from 0 (least significant) to 31 (most significant). All accessed bits must be in the range [0, 31].

The default for width is 1.

`bit32.replace (n, v, field [, width])`

Returns a copy of n with the bits field to field + width - 1 replaced by the value v. See bit32.extract for details about field and width.

`bit32.lrotate (x, disp)`

Returns the number x rotated disp bits to the left. The number disp may be any representable integer.

For any valid displacement, the following identity holds:

     assert(bit32.lrotate(x, disp) == bit32.lrotate(x, disp % 32))
In particular, negative displacements rotate to the right.

`bit32.lshift (x, disp)`

Returns the number x shifted disp bits to the left. The number disp may be any representable integer. Negative displacements shift to the right. In any direction, vacant bits are filled with zeros. In particular, displacements with absolute values higher than 31 result in zero (all bits are shifted out).

For positive displacements, the following equality holds:

     assert(bit32.lshift(b, disp) == (b * 2^disp) % 2^32)
`bit32.rrotate (x, disp)`

Returns the number x rotated disp bits to the right. The number disp may be any representable integer.

For any valid displacement, the following identity holds:

     assert(bit32.rrotate(x, disp) == bit32.rrotate(x, disp % 32))
In particular, negative displacements rotate to the left.

`bit32.rshift (x, disp)`

Returns the number x shifted disp bits to the right. The number disp may be any representable integer. Negative displacements shift to the left. In any direction, vacant bits are filled with zeros. In particular, displacements with absolute values higher than 31 result in zero (all bits are shifted out).

For positive displacements, the following equality holds:

     assert(bit32.rshift(b, disp) == math.floor(b % 2^32 / 2^disp))
This shift operation is what is called logical shift.

6.8 – Input and Output Facilities

The I/O library provides two different styles for file manipulation. The first one uses implicit file descriptors; that is, there are operations to set a default input file and a default output file, and all input/output operations are over these default files. The second style uses explicit file descriptors.

When using implicit file descriptors, all operations are supplied by table io. When using explicit file descriptors, the operation io.open returns a file descriptor and then all operations are supplied as methods of the file descriptor.

The table io also provides three predefined file descriptors with their usual meanings from C: io.stdin, io.stdout, and io.stderr. The I/O library never closes these files.

Unless otherwise stated, all I/O functions return nil on failure (plus an error message as a second result and a system-dependent error code as a third result) and some value different from nil on success. On non-Posix systems, the computation of the error message and error code in case of errors may be not thread safe, because they rely on the global C variable errno.

`io.close ([file])`

Equivalent to file:close(). Without a file, closes the default output file.

`io.flush ()`

Equivalent to io.output():flush().

`io.input ([file])`

When called with a file name, it opens the named file (in text mode), and sets its handle as the default input file. When called with a file handle, it simply sets this file handle as the default input file. When called without parameters, it returns the current default input file.

In case of errors this function raises the error, instead of returning an error code.

`io.lines ([filename ···])`

Opens the given file name in read mode and returns an iterator function that works like file:lines(···) over the opened file. When the iterator function detects the end of file, it returns nil (to finish the loop) and automatically closes the file.

The call io.lines() (with no file name) is equivalent to io.input():lines(); that is, it iterates over the lines of the default input file. In this case it does not close the file when the loop ends.

In case of errors this function raises the error, instead of returning an error code.

`io.open (filename [, mode])`

This function opens a file, in the mode specified in the string mode. It returns a new file handle, or, in case of errors, nil plus an error message.

The mode string can be any of the following:

"r": read mode (the default);
"w": write mode;
"a": append mode;
"r+": update mode, all previous data is preserved;
"w+": update mode, all previous data is erased;
"a+": append update mode, previous data is preserved, writing is only allowed at the end of file.
The mode string can also have a 'b' at the end, which is needed in some systems to open the file in binary mode.

`io.output ([file])`

Similar to io.input, but operates over the default output file.

`io.popen (prog [, mode])`

This function is system dependent and is not available on all platforms.

Starts program prog in a separated process and returns a file handle that you can use to read data from this program (if mode is "r", the default) or to write data to this program (if mode is "w").

`io.read (···)`

Equivalent to io.input():read(···).

`io.tmpfile ()`

Returns a handle for a temporary file. This file is opened in update mode and it is automatically removed when the program ends.

`io.type (obj)`

Checks whether obj is a valid file handle. Returns the string "file" if obj is an open file handle, "closed file" if obj is a closed file handle, or nil if obj is not a file handle.

`io.write (···)`

Equivalent to io.output():write(···).

`file:close ()`

Closes file. Note that files are automatically closed when their handles are garbage collected, but that takes an unpredictable amount of time to happen.

When closing a file handle created with io.popen, file:close returns the same values returned by os.execute.

`file:flush ()`

Saves any written data to file.

`file:lines (···)`

Returns an iterator function that, each time it is called, reads the file according to the given formats. When no format is given, uses "*l" as a default. As an example, the construction

     for c in file:lines(1) do body end
will iterate over all characters of the file, starting at the current position. Unlike io.lines, this function does not close the file when the loop ends.

In case of errors this function raises the error, instead of returning an error code.

`file:read (···)`

Reads the file file, according to the given formats, which specify what to read. For each format, the function returns a string (or a number) with the characters read, or nil if it cannot read data with the specified format. When called without formats, it uses a default format that reads the next line (see below).

The available formats are

"*n": reads a number; this is the only format that returns a number instead of a string.
"*a": reads the whole file, starting at the current position. On end of file, it returns the empty string.
"*l": reads the next line skipping the end of line, returning nil on end of file. This is the default format.
"*L": reads the next line keeping the end of line (if present), returning nil on end of file.
number: reads a string with up to this number of bytes, returning nil on end of file. If number is zero, it reads nothing and returns an empty string, or nil on end of file.
file:seek ([whence [, offset]])

Sets and gets the file position, measured from the beginning of the file, to the position given by offset plus a base specified by the string whence, as follows:

"set": base is position 0 (beginning of the file);
"cur": base is current position;
"end": base is end of file;
In case of success, seek returns the final file position, measured in bytes from the beginning of the file. If seek fails, it returns nil, plus a string describing the error.

The default value for whence is "cur", and for offset is 0. Therefore, the call file:seek() returns the current file position, without changing it; the call file:seek("set") sets the position to the beginning of the file (and returns 0); and the call file:seek("end") sets the position to the end of the file, and returns its size.

file:setvbuf (mode [, size])

Sets the buffering mode for an output file. There are three available modes:

"no": no buffering; the result of any output operation appears immediately.
"full": full buffering; output operation is performed only when the buffer is full or when you explicitly flush the file (see io.flush).
"line": line buffering; output is buffered until a newline is output or there is any input from some special files (such as a terminal device).
For the last two cases, size specifies the size of the buffer, in bytes. The default is an appropriate size.

`file:write (···)`

Writes the value of each of its arguments to file. The arguments must be strings or numbers.

In case of success, this function returns file. Otherwise it returns nil plus a string describing the error.

6.9 – Operating System Facilities

This library is implemented through table os.

`os.clock ()`

Returns an approximation of the amount in seconds of CPU time used by the program.

`os.date ([format [, time]])`

Returns a string or a table containing date and time, formatted according to the given string format.

If the time argument is present, this is the time to be formatted (see the os.time function for a description of this value). Otherwise, date formats the current time.

If format starts with '!', then the date is formatted in Coordinated Universal Time. After this optional character, if format is the string "*t", then date returns a table with the following fields: year (four digits), month (1–12), day (1–31), hour (0–23), min (0–59), sec (0–61), wday (weekday, Sunday is 1), yday (day of the year), and isdst (daylight saving flag, a boolean). This last field may be absent if the information is not available.

If format is not "*t", then date returns the date as a string, formatted according to the same rules as the ISO C function strftime.

When called without arguments, date returns a reasonable date and time representation that depends on the host system and on the current locale (that is, os.date() is equivalent to os.date("%c")).

On non-Posix systems, this function may be not thread safe because of its reliance on C function gmtime and C function localtime.

`os.difftime (t2, t1)`

Returns the number of seconds from time t1 to time t2. In POSIX, Windows, and some other systems, this value is exactly t2-t1.

`os.execute ([command])`

This function is equivalent to the ISO C function system. It passes command to be executed by an operating system shell. Its first result is true if the command terminated successfully, or nil otherwise. After this first result the function returns a string and a number, as follows:

"exit": the command terminated normally; the following number is the exit status of the command.
"signal": the command was terminated by a signal; the following number is the signal that terminated the command.
When called without a command, os.execute returns a boolean that is true if a shell is available.

`os.exit ([code [, close]) » boolean or number`
    Calls the ISO C function exit to terminate the host program
    Returns `true` on success, `false` on failure or code number
    If `close` is `true`, closes the Lua state before exiting.

`os.getenv (varname) » mixed`
    Returns the environment `variable` varname, or nil

`os.remove (filename) » <true> or <nil, "error message">`
    Deletes the file (or empty directory, on POSIX systems)

`os.rename (oldname, newname) » <true> or <nil, "error message">`
    Renames file or directory named oldname to newname.

`os.setlocale (loc [, cat]) » string or nil`
    Sets the current locale of the program. Return the chosen locale string or `nil` on error
    * `loc` - if string, a system-dependent string
            - if `nil` get current locale for givel `cat`
    * `cat` - "all" (default),
            - "collate"
            - "ctype"
            - "monetary"
            - "numeric"
            - "time"

`os.time () » number` returns current time
`os.time ([table])`

Returns the current time when called without arguments, or a time representing the date and time specified by the given table. This table must have fields year, month, and day, and may have fields hour (default is 12), min (default is 0), sec (default is 0), and isdst (default is nil). For a description of these fields, see the os.date function.

The returned value is a number, whose meaning depends on your system. In POSIX, Windows, and some other systems, this number counts the number of seconds since some given start time (the "epoch"). In other systems, the meaning is not specified, and the number returned by time can be used only as an argument to os.date and os.difftime.

`os.tmpname ()`

Returns a string with a file name that can be used for a temporary file. The file must be explicitly opened before its use and explicitly removed when no longer needed.

On POSIX systems, this function also creates a file with that name, to avoid security risks. (Someone else might create the file with wrong permissions in the time between getting the name and creating the file.) You still have to open the file to use it and to remove it (even if you do not use it).

When possible, you may prefer to use io.tmpfile, which automatically removes the file when the program ends.

6.10 – The Debug Library

This library provides the functionality of the debug interface (§4.9) to Lua programs. You should exert care when using this library. Several of its functions violate basic assumptions about Lua code (e.g., that variables local to a function cannot be accessed from outside; that userdata metatables cannot be changed by Lua code; that Lua programs do not crash) and therefore can compromise otherwise secure code. Moreover, some functions in this library may be slow.

All functions in this library are provided inside the debug table. All functions that operate over a thread have an optional first argument which is the thread to operate over. The default is always the current thread.

`debug.debug ()`
Enters an interactive mode with the user, running each string that the user enters.

`debug.gethook ([thread]) » hook_fn(), hook_mask, hook_count`
Get 3 values for the current hook settings of the thread

`debug.getinfo ([thread,] f [, what])`
Returns a table with information about a function.
You can give the function directly or you can give a number as the value of f, which means the function running at level f of the call stack of the given thread: level 0 is the current function (getinfo itself); level 1 is the function that called getinfo (except for tail calls, which do not count on the stack); and so on. If f is a number larger than the number of active functions, then getinfo returns nil.

The returned table can contain all the fields returned by lua_getinfo, with the string what describing which fields to fill in. The default for what is to get all information available, except the table of valid lines. If present, the option 'f' adds a field named func with the function itself. If present, the option 'L' adds a field named activelines with the table of valid lines.

For instance, the expression debug.getinfo(1,"n").name returns a table with a name for the current function, if a reasonable name can be found, and the expression debug.getinfo(print) returns a table with all available information about the print function.

`debug.getlocal ([thread,] f, local)`

This function returns the name and the value of the local variable with index local of the function at level f of the stack. This function accesses not only explicit local variables, but also parameters, temporaries, etc.

The first parameter or local variable has index 1, and so on, until the last active variable. Negative indices refer to vararg parameters; -1 is the first vararg parameter. The function returns nil if there is no variable with the given index, and raises an error when called with a level out of range. (You can call debug.getinfo to check whether the level is valid.)

Variable names starting with '(' (open parenthesis) represent internal variables (loop control variables, temporaries, varargs, and C function locals).

The parameter f may also be a function. In that case, getlocal returns only the name of function parameters.

`debug.getmetatable (value)`

Returns the metatable of the given value or nil if it does not have a metatable.

`debug.getregistry ()`

Returns the registry table (see §4.5).

`debug.getupvalue (f, up)`

This function returns the name and the value of the upvalue with index up of the function f. The function returns nil if there is no upvalue with the given index.

`debug.getuservalue (u)`

Returns the Lua value associated to u. If u is not a userdata, returns nil.

`debug.sethook ([thread,] hook, mask [, count])`

Sets the given function as a hook. The string mask and the number count describe when the hook will be called. The string mask may have any combination of the following characters, with the given meaning:

'c': the hook is called every time Lua calls a function;
'r': the hook is called every time Lua returns from a function;
'l': the hook is called every time Lua enters a new line of code.
Moreover, with a count different from zero, the hook is called also after every count instructions.

When called without arguments, debug.sethook turns off the hook.

When the hook is called, its first parameter is a string describing the event that has triggered its call: "call" (or "tail call"), "return", "line", and "count". For line events, the hook also gets the new line number as its second parameter. Inside a hook, you can call getinfo with level 2 to get more information about the running function (level 0 is the getinfo function, and level 1 is the hook function).

`debug.setlocal ([thread,] level, local, value)`

This function assigns the value value to the local variable with index local of the function at level level of the stack. The function returns nil if there is no local variable with the given index, and raises an error when called with a level out of range. (You can call getinfo to check whether the level is valid.) Otherwise, it returns the name of the local variable.

See debug.getlocal for more information about variable indices and names.

`debug.setmetatable (value, table)`

Sets the metatable for the given value to the given table (which can be nil). Returns value.

`debug.setupvalue (f, up, value)`

This function assigns the value value to the upvalue with index up of the function f. The function returns nil if there is no upvalue with the given index. Otherwise, it returns the name of the upvalue.

`debug.setuservalue (udata, value)`

Sets the given value as the Lua value associated to the given udata. value must be a table or nil; udata must be a full userdata.

Returns udata.

`debug.traceback ([thread,] [message [, level]])`

If message is present but is neither a string nor nil, this function returns message without further processing. Otherwise, it returns a string with a traceback of the call stack. An optional message string is appended at the beginning of the traceback. An optional level number tells at which level to start the traceback (default is 1, the function calling traceback).

`debug.upvalueid (f, n)`

Returns an unique identifier (as a light userdata) for the upvalue numbered n from the given function.

These unique identifiers allow a program to check whether different closures share upvalues. Lua closures that share an upvalue (that is, that access a same external local variable) will return identical ids for those upvalue indices.

`debug.upvaluejoin (f1, n1, f2, n2)`

Make the n1-th upvalue of the Lua closure f1 refer to the n2-th upvalue of the Lua closure f2.

# Lua Command Line

     lua [options] [script [args]]

The options are:

-e stat: executes string stat;
-l mod: "requires" mod;
-i: enters interactive mode after running script;
-v: prints version information;
-E: ignores environment variables as LUA_PATH, LUA_CPATH and LUA_INIT
--: stops handling options;
-: executes stdin as a file and stops handling options.
When called without arguments, lua behaves as lua -v -i when the standard input (stdin) is a terminal.


<!--
vim: ts=4 sts=4 sw=4 expandtab
-->
