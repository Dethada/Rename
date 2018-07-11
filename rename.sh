#!/bin/bash

FOLDERPATH="$PWD"
BACKEND="SED"
DEBUG="FALSE"

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -t|--target)
    FOLDERPATH="$2"
    shift # past argument
    shift # past value
    ;;
    -e|--expression)
    EXPRESSION="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--help)
    HELP="YES"
    shift # past argument
    ;;
    -p|--perl)
    BACKEND="PERL"
    shift
    ;;
    --debug)
    DEBUG="TRUE"
    shift
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ "$HELP" == "YES" ]]
then
    printf "Sending help"
    exit 0
fi

if [ -z "$FOLDERPATH" ] || [ -z "$EXPRESSION" ]
then
    echo "Missing arguments"
    exit 1
fi

if [[ "$FOLDERPATH" != */ ]]
then # append slash if missing
    FOLDERPATH="$FOLDERPATH/"
fi

if [[ "$DEBUG" == "TRUE" ]]
then
    echo FOLDER PATH     = "${FOLDERPATH}"
    echo EXPRESSION      = "${EXPRESSION}"
    echo BACKEND         = "${BACKEND}"
    echo HELP            = "${HELP}"
fi

# T(.*) selects everything after T
# https://stackoverflow.com/questions/7124778/how-to-match-anything-up-until-this-sequence-of-characters-in-a-regular-expres
# /START.+?(?=END)/

if [[ "$BACKEND" == "SED" ]]
then
    for i in "$FOLDERPATH"*; do mv "$i" "`basename "$i" | sed -E "$EXPRESSION"`"; done
else
    for i in "$FOLDERPATH"*; do mv "$i" "`basename "$i" | perl -pe "$EXPRESSION"`"; done
fi
