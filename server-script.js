const fs = require("fs");
var login = require("facebook-chat-api");

var email_addr = process.argv[2];
var passwd = process.argv[3];
console.log("[Sanity check] Email address read as "+email_addr);

var makeDirsExecutor = require("child_process");

/*const result = makeDirsExecutor.execSync("bash test_script.sh");*/
/*var strRep = console.log(result.toString());*/
login({ email: email_addr, password: passwd}, function callback(err, api) {
    if (err) {
        return console.error(err);
    }
    api.setOptions({listenEvents : true});
    /* */
    var stopListening = api.listen( function(err, event) {
        /*    */
/*        console.log("[DEBUG] About to switch / case on the message type");*/
        if (event == undefined) {
            return;
        }
        switch (event.type) {
            case "message":
                /* General idea:
                 * Log it in the file system */
                var threadID = event.threadID;
                api.getThreadInfo/*GraphQL*/(threadID, function (err, info) {
                    if (err) {
                        console.error(err);
                        return;
                    }
                    var currentTimeData = new Date();
                    var seconds = currentTimeData.getTime() / 1000;
/*                    var ms = currentTimeData.getTime() % 1000;*/
                    var updateMsg = (seconds+": "+event.body/*+"\n"*/);
                    var primaryMsg = "About to log the message:";
                    if (event.isUnread) {
                        primaryMsg = primaryMsg+" * (unread!)";
                    }
                    if (event.isGroup) {
                        console.log("[GROUP THREAD] "+primaryMsg);
                    } else {
                        console.log(primaryMsg);
                    }
                    console.log("\tTHREAD ID "+event.threadID);
                    console.log("\t"+updateMsg);
                    var key = event.senderID;
/*                    var key2 = event.nicknames;*/
                    console.log("[DEBUG] Thread info gives us: Sender ID \""+key+"\""/* and nicknames "+key2*/);
/*                    const result = makeDirsExecutor.execSync("bash process-one-config.sh "+key+" "+threadID)*/
/*                    console.log(result.toString());*/
                    var msgFile = "meta/"+event.threadID+"/msg.txt";
                    var timeFile = "meta/"+event.threadID+"/time.txt";
                    fs.appendFileSync(msgFile, updateMsg);
                    
                    /* TODO if the timestamp is
                     * to be saved in a separate file, then
                     * use the next line
                     * (and make sure the file is overwritten)  */
/*                    fs.();*/
                    
                    /* Uncomment in order to MARK messages as read */
/*                    api.markAsRead(event.threadID);*/

                    /* Change colors, just as a fun trick */
                    
                });
                break;
            case "event":
                console.log("Event type EVENT (non-message) is being logged.");
                console.log(event);
                break;
            case "read":
                console.log("Just SENT read status on message thread "+event.threadID+".");
                break;
            case "read_receipt":
                var timeStamp = event.time / 1000;
                console.log("["+timeStamp+"] "+event.reader+" has viewed messages. (Thread ID "+event.threadID+")");
                break;
        }
/*        console.log("[DEBUG] Ok, now outside the switch/case.");*/
/*        console.log("[DEBUG] About to check for errors...");*/
        if (err) {
            console.log("[ERR] server-script `err` is non-NULL! This could be bad.");
            return console.error(err);
        }
    });
});

