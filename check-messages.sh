#!/bin/bash
#
# This is the client shell script, to connect to a user's
# Facebook messages and provide a basic interface
# for real-time communication
# (It should be used in conjunction with other scripts
# [possibly using Node.js] that will take care of the
# actual connecting, receiving, and sending Fcacebook messages).
#
###
# First, define some terms:
set -o errexit
set -o nounset
PROMPT=">>"
function check_for_messages {
    msg_file="meta/"$1"/msg.txt"
    msg_copy_file="meta/"$1"/msg-copy.txt"
    last_check_time=$(date +%s)
#    echo "[DEBUG] About to copy into the msg-copy file"
    cp -p $msg_file $msg_copy_file
#    echo "[DEBUG] Just copied into the msg-copy file"
    newmsg=$(diff $msg_file $msg_copy_file)
    while [ "$newmsg" != "" ]; do
        rm -f $msg_copy_file
        last_check_time=$(date +%s)
        cp -p $msg_file $msg_copy_file
        newmsg=$(diff $msg_file $msg_file)
    done
    cat "$msg_copy_file"
    echo "$last_check_time" > "meta/"$1"/last_check.txt"
}
# Now begin the main sequence of the script
echo -n "Enter your email address (for Facebook login): "
read username
echo -n "Enter your password, for authentication: "
read -s password
pushd .
cd $(cat $HOME/)
node authenticate.js "$username" "$password"
res=$?
if [ $res -ne 0 ]; then
echo "Problem authenticating. Now exiting."
exit $res
fi
num_args=$#;
if [ $num_args -lt 1 ]; then
  echo "With whom do you want to chat? "
  read subject
else
  subject=$1
fi

# Now assume the subject has been set
echo -n "Subject identified as "
echo $subject
subjectLine=$(cat .config | grep $subject)
indexOfComma=`expr index "$subjectLine" ,`
subjectID=${subjectLine: $indexOfComma}
timestamp=$(date +%s)
echo "subjectID identified as "$subjectID
# the following (if uncommented) will account for nanoseconds
#timestamp=$(date +%s%N)
echo $timestamp
last_updatetime=$(stat -c %X "meta/"$subjectID"/msg.txt")
last_checktime=$(cat "meta/"$subjectID"/last_check.txt") # $(cat "meta/"$subjectID"/msg.txt")

# Now that the recent messages have been CAPTURED,
# replace the file with an empty file.
echo "" > "meta/"$subjectID"/-recent-msg.txt"
if [ $last_checktime -gt $last_updatetime ]; then
  # No new messages
  echo "There are no new messages since the last check."
else
  cat "meta/"$subjectID"/msg-copy.txt"
  # Add code to deal with the race condition here!
  # ...
  # ... in development ...
  # ...
fi
response=""
while [ "$response" != "/done" ]; do
  # check for new messages
  check_for_messages $subjectID
  # echo "~This is the moment that another script would be called to check for new messages~"
  # echo "Then the new messages would be printed here in order with timestamp."
  # and then offer the user the ability to reply.
  echo "your reply? (Or enter '/done' to exit or '/skip' to refresh inbox again)"
  echo -n $PROMPT
  read response
  if [ "$response" != "/skip" ]; then
    if [ "$response" != "/done" ]; then
#      response="HAHAHA"
#      echo $response
      if [ "$response" == "" ]; then
        echo ""
      else
        echo "Would be SENDING "$response" right now... (again, still in development)"
        node send_message.js $username "$password" "$subjectID" "$response"
      fi
    else
      echo ""
    fi
  else
    # skip this iteration! Check messages again.
    echo ""
  fi
done
