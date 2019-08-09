#!/bin/bash
#
# configure.sh
# 
# A new user should run this at least once before calling other scripts.
# This  configuration can be run multiple times as explained below.
# 
# A .config file will be developed, containing a hashtable:
# Each line contains
# <user-specified name>,<threadID>
# Note that the threadIDs in this list need not be distinct!
# (So a user can give a single chat thread multiple identifiers,
#  if desired.)
# 
# In order to add a new entry, activate the configuration script
# and then (in a browser) send a message in an existing (or new?) chat thread.
# The terminal will prompt for a name and then add the line into .config .
# 
# Then, automatically, the script will generate the directory structure
# (setting up one directory for each unique chat thread, if the directory
#  doesn't already exist).
# 
###
set -o errexit
set -o nounset
next_name=""
echo -n "Enter your FB username/email: "
read email
echo -n "Enter your FB password, for authentication: "
read -s password
echo "Please enter the ABSOLUTE PATH of the directory where these scripts will be saved,"
echo "or simply enter newline to use the current directory"
read localdir  
echo "$localdir"
if [ "$localdir" == "" ]; then
  pwd > $HOME/.fb-home-dir.cfg
else
  pushd .
  cd $localdir
  pwd > $HOME/.fb-home-dir.cfg
fi

echo $localdir

# Then the nodejs script should take care of all the rest
node discover-threadIDs.js $email "$password"
echo "Finished adding names."

# Next goal:
## Process each line of the .config file;
## If the directory for that line does not already exist,
## then add it to the system.
while read -r next_entry; do
    indexOfComma=`expr index "$next_entry" ,`
    next_entry_id=${next_entry: $indexOfComma}
    echo "    Now processing the subject id "$next_entry_id
    if [ -d "meta/$next_entry_id" ]; then
        # directory already exists, so just ignore this case
        echo "Directory already exists?"
    else
        mkdir meta/$next_entry_id
        touch meta/$next_entry_id/msg.txt
        echo "0" > meta/$next_entry_id/last_check.txt
        echo "[SUCCESS] Created directory for "$next_entry_id
    fi
done < ".config"
echo "Finished processing names."
echo "Configuration finished."
