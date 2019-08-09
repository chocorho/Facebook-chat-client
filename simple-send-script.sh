#!/usr/bin/env bash
# 
# Simple test to make sure it's doable
# to send a message through a facebook chat bot
# 
###
set -o errexit
set -o nounset
echo -n "Enter your email address (for Facebook login): "
read username
echo -n "Enter your password, for authentication: "
read -s password
echo ""
echo -n "Enter the user-defined name of the recipient (the key): "
read subjectName
subjectLine=$(cat .config | grep $subjectName | head -n 1)
echo -n "subjectLine var: "
echo "$subjectLine"
indexOfComma=`expr index "$subjectLine" ","`
subjectID=${subjectLine: $indexOfComma}
#echo "Recipient ID read as ""$subjectID"
echo -n "Enter message in: "
echo -n "3... "
sleep 1
echo -n "2... "
sleep 1
echo "1... "
sleep 1
if [ "$EDITOR" = "" ]; then
    read response;
else
    $EDITOR ._respo.txt
    response=`cat ._respo.txt`
#    rm -f ._respo.txt
fi
node send_message.js $username "$password" "$subjectID" "$response"
echo -n "You: " >> meta/$subjectID/msg.txt
echo "$response" >> meta/$subjectID/msg.txt
echo "Test script finished."
