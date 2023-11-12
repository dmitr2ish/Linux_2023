#!/bin/bash
# This script finds .sh files with specified symbolic permissions in your home directory and outputs a sorted list.
# To use it, execute with a single permission parameter in symbolic form (e.g., rwxr-xr-x, r-xr--r--, etc.).
# Run the script as ./search_scripts_by_permissions.sh <permissions>, replacing <permissions> with the desired permission set and
# search_scripts_by_permissions.sh with the script's filename. The output will be a list of filenames, saved to a file output.txt.

# checking parameter
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <permissions>"
  exit 1
fi

# creating map of permissions
declare -A perms=( ["---"]=0 ["--x"]=1 ["-w-"]=2 ["-wx"]=3 ["r--"]=4 ["r-x"]=5 ["rw-"]=6 ["rwx"]=7 )

perm="$1"
numeric_perm=

# dividing permissions by three symbols and building permission search rule
for ((i=0; i<${#perm}; i+=3)); do
  three_perm=${perm:i:3}
  numeric_perm+=${perms[$three_perm]}
  echo "$three_perm -> $numeric_perm"
done
echo "Current numeric permission for search is $numeric_perm"

# the name of the answer file, it is better to specify it also as an argument,
# but it is not suitable for the current task
answer_file=output.txt

# using the find command for search by permission rule and sorting by name
find ~ -type f -name "*.sh" -perm "/$numeric_perm"| sort > $answer_file

echo "Answer is ready! Please check $answer_file"