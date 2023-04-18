#!/bin/bash

help="HELP:
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

  usage: modify [-r] [-l|-u] <dir/file names...> || modify [-r] <sed pattern> <dir/file names...> || modify [-h]";

  all_args=($*); # all arguments passed during call
  args=(); # path and sed
  params=(false false); # run options
  self_name=$(basename $0);

#-------PREP FUCNTIONS-------

function getArguments() { #stores path and sed pattern in args array
    
    for i in "${!all_args[@]}"; do
    if [ ${all_args[i]} != '-r' ] && [ ${all_args[i]} != '-l' ] && [ ${all_args[i]} != '-u' ]; then
        if [ -f ${all_args[i]} ] || [ -d ${all_args[i]} ]; then #if file or directory

            [ -z ${agrs[0]+x} ] || error_msg "Too many paths"; #if path is already stored
            args[0]=${all_args[i]}; #store path if it is not stored yet

        elif [[ -n ${all_args[i]} ]]; then # proper sed?

            [ -z ${args[1]+x} ] || error_msg "Too many sed patterns"; #if sed is already stored
            args[1]=${all_args[i]}; #store sed pattern

        fi
    fi
    done
    
}

function error_msg() {

        echo "Error: $1" 1>&2 
        exit 1;

}

#-------NAME CHANGING FUNCTIONS-------        

function modifyName() { #changes name of one file passed in $1 

    path="$1";
    local filename=$(basename "$path");
    local directory=$(dirname "$path");

    [ "$filename" = "$self_name" ] && return 1;

    if [ ! -f "$path" ]; then 
    [ -d ${args[0]} ] && [ "$path" = "$base_path" ] && return 1;
    fi

    if [ "${params[1]}" = "u" ]; then   
        new_filename=`echo "$filename" | tr '[:lower:]' '[:upper:]'`
        
    elif [ "${params[1]}" = "l" ]; then 
        new_filename=`echo "$filename" | tr '[:upper:]' '[:lower:]'`

    else 
        new_filename=`echo "$filename" | sed "${args[1]}"`
        [ -z "$new_filename" ] && return 1;
    fi
    [ "$new_filename" = "$filename" ] && return 1;
    new_path=$directory/$new_filename;
    [ -e "$new_path" ] && return 1;

    mv -f "$path" "$new_path";

}

function modifyNames() { # path passed in $1

    base_path="$1";

    find $1 -maxdepth 1 \( -type f -o -type d \) | while read i; do # searching for files only in passed directory (no subdirectories)
        modifyName "$i";
    done

}

function r_modifyNames() { # path passed in $1

    base_path="$1";

    find $1 \( -type f -o -type d \) | while read i; do # searching for files in passed directory and all subdirectories
        [ -e "$i" ] || continue;
        modifyName "$i";
        [ -d "$new_path" ] && [ "$path" != "$base_path" ] && r_modifyNames "$new_path"; # if directory was changed, recursively call function to change all files in it, (path != base_path to avoid infinite loop)
    done

}

#------MAIN PART-------

while getopts "hrlu" options; do
        case "${options}" in
            \?)
                error_msg "Invalid parameter (-$OPTARG)."
                ;;
            h)
                echo $help
                exit
                ;;
            r)
                params[0]='r';
                ;;
            u)
                params[1]='u';
                ;;
            l)
                params[1]='l';
        esac
    done

[ -z "$all_args" ] && error_msg "No parameters or options passed";
[ ${#all_args[*]} -eq 1 ] && error_msg "Only one parameter passed";

getArguments;

[ -z ${args[0]} ] && error_msg "No path passed";

if [ "${params[0]}" = "r" ]; then
        r_modifyNames ${args[0]};

    else
        modifyNames  ${args[0]};
fi
