# General Comments

not in a great state at the moment, I was a bit busy and didn't have the time to properly improve it beyond just getting the basic specification working

it is whitespace-agnostic, semi-colons between statements and spaces between keywords and variable names and such are the only things that matter.

i plan on doing some proper lexing and such later, as well as a more robust interpreter system that allows line-by-line stepping, and a REPL.

i do like the stack idea i'm going for with regards to dealing with nested loops (and in future, functions?), but the logic could definitely be made cleaner

# Usage

`lune run interpreter [filename]` you can include a `.bb` extension in the file name if you'd like. so e.g. to run `example1.bb` you could either use `example1.bb` or just `example1` (this mimics the behaviour of lune wherein it doesn't require the `.luau` extension to run a script.)
