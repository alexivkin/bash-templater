#!/bin/bash

# Generic BASH template renderer

# Substitutes '${VAR}' string in the provided file with a value from the VAR environmnet variable
# VAR can be any bash env var name

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

render $1