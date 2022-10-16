# Generic Bash template renderer

Substitutes `${VAR}` string in the provided file with a value from the $VAR environmnet variable, where $VAR is a bash environment variable with any name.

A custom alternative for `envsubst` from the gettext-base package.

* `render.sh` - processes a file given to it as the first argument
* `render-all.sh` - processes all files from the templates/ subfolder using the variables from a given file, and generates files in the current folder
