#!/bin/bash
#
set -o errexit
set -o nounset
echo -n "Enter your email address (for Facebook login): "
read username
echo -n "Enter your password, for authentication: "
read -s password
echo ""
echo "Now about to start listening for new messages..."
pushd .
FBHOMEDIR=$(cat $HOME/.fb-home-dir.cfg)
cd $FBHOMEDIR
node $FBHOMEDIR"/server-script.js" $username "$password" # "$subjectID" "$response"
popd
echo "Test script finished."
