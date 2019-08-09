#!/usr/bin/env bash
# 
# 
###
key=$1
val=$2
indexOfComma=`expr index "$next_entry" ,`
next_entry_id=${next_entry: $indexOfComma}
#echo "    Now processing the subject id "$next_entry_id
if [ -d "meta/$next_entry_id" ]; then
    #no-op
    echo -n ""
else
    echo "\n" >> .config
    echo $1 >> .config
    echo "," >> .config
    echo $2 >> .config
    mkdir meta/$next_entry_id
    touch meta/$next_entry_id/msg.txt
    echo "0" > meta/$next_entry_id/last_check.txt
#    echo "[SUCCESS]Created directory for "$next_entry_id
#                var msgFile = "meta/"+event.threadID+"/msg.txt";
#                var timeFile = "meta/"+event.threadID+"/time.txt";
#                var updateMsg = (toBeLogged+": "+event.body+"\n");
#                fs.appendFileSync(msgFile, updateMsg);
fi
#echo "Finished processing names."
