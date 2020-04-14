#!/bin/bash

usage(){
   cat << eof
This is a script designed to delete empty lines & change lowercase characters to uppercase.
Usage: $0 [file(s)]
Examples:
    $0 --help
    $0 example.txt
eof
}

if [[ -e $1 ]] ; then
    sed -e 's/\(.*\)/\U\1/; /^$/d' $1 | sudo tee $1
elif [[ $1 == --help ]] ; then
    usage
    exit 0
else echo "error in arguments"
fi
