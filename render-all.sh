#!/bin/bash
#
# Simple bash templating engine. Takes a sourced variables from the environment, templates from a templates/ subfolder and generates new files in the current folder
#
# The special "clean" argument removes all files that it created

if [[ $# -eq 0 ]]; then
   echo Give me a file with the variables defined for the environment or 'clean' to remove generated files
   exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )" # folder where this script is at

if [[ $1 == "clean" ]]; then
   for i in $DIR/templates/*; do
      rm -f "$DIR/$(basename $i)"
   done
   echo "Cleaned"
   exit
elif [[ ! -f "$DIR/$1" ]]; then
   echo "Cannot find $DIR/$1"
   exit 2
elif [[ ! -d "$DIR/templates" ]]; then
   echo "No 'templates' subfolder under $DIR/"
   exit 2
fi

source $DIR/$1

render(){
    file="$1"
    IFS=''
    while read -r line || [ -n "$line" ]; do # || is to catch the last line that may end with EOF instead of \n
        while [[ "$line" =~ (\$\{[a-zA-Z_][a-zA-Z_0-9]*\}) ]] ; do
              LHS=${BASH_REMATCH[1]}
              RHS="$(eval echo "\"$LHS\"")"
              if [[ -z "$RHS" ]]; then
                 break # break on an undefined variable, so we dont loop forever
              fi
              line=${line//$LHS/$RHS}
        done
        echo "$line"
    done < $file
}

for i in $DIR/templates/*; do
    render "$i" > "$DIR/$(basename $i)"
    chmod --reference="$i" "$DIR/$(basename $i)"
    echo "Created $(basename $i)"
done

echo chmod u+x *.sh
