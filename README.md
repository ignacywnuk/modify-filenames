Write a script modify with the following syntax:

 modify [-r] [-l|-u] <dir/file names...>
 modify [-r] <sed pattern> <dir/file names...>
 modify [-h]

which will modify file names. The script is dedicated to lowerizing (-l)
file names, uppercasing (-u) file names or internally calling sed
command with the given sed pattern which will operate on file names.
Changes may be done either with recursion (-r) or without it. -r doesn't take arguments so it's a standalone option.

Write a second script, named modify_examples, which will lead the tester of the modify script through the typical, uncommon and even incorrect scenarios of usage of the modify script.
  (-u) - uppercasing all file names and directories
  (-l) - lowerizing all file names and directories
  (-r) - recursively change file and directory names with given options -u or -l
  (-h) - help

  usage: modify [-r] [-l|-u] <dir/file names...> || modify [-r] <sed pattern> <dir/file names...> || modify [-h]