#!/bin/bash

usage(){
    cat << eof
-------------------------------------------
$0 script crates files in specified catalog.
If you use argument -d twice you will get an error and program will end with code 2.
If specified directory does not exists you will get an error and program will end with code 3.
Specifing any other arguments wil get an error and program will end with code 4.
Using more than one directory in arguments will display an error and give error code 5
A warning message displays if one or more files in arguments already exists, but others will be created.
Also all files with .sh extension will automaticaly get rights to be executed.
Examples:
    $0 --help
    $0 -d /tmp/folder file1.txt
    $0 -d /tmp/folder file1.txt file2.sh
-------------------------------------------
eof
}

flagd="false"
dir=`dirname $0`

while [[ $# -gt 0 ]] ; do
    case $1 in
      --help)
      usage
      exit 0
    ;;
    -d)
        if [ "$flagd" == "true" ] ; then
          echo "Argument -d already used"
          exit 2
        else
            flagd="true"
            shift
            if [[ -d $1 ]] ; then
              dir=$1
              shift && continue
            else
              echo "Directory does not exists"
              exit 3
            fi
        fi
    ;;
    -*|--*)
      echo "Wrong arguments"
      exit 4
    ;;
    *)
      if [[ -d $1 ]] ; then
        echo "Error! The directory is already specified"
        exit 5
      elif [[ -f "$dir/$1" ]] ; then
        echo "Warning! File "$1" already exists"
        shift
      else
        FILES+="$1 "
        if [[ $1 == *.sh ]] ; then
          FILES_SH+="$1 "
        fi
        shift
      fi
    esac
done

(( ${#FILES[@]} == 0 )) && echo "Files not specified or already exist" && exit 6
cd $dir
touch $FILES
if [[ ${#FILES_SH[@]} != 0 ]] ; then
  chmod +x $FILES_SH
fi
