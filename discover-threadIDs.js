const fs = require("fs");
var login = require("facebook-chat-api");
var direct_input = require("prompt");

var email_addr = process.argv[2];
var passwd = process.argv[3];
console.log("[Sanity check] Email address read as "+email_addr);

login({ email: email_addr, password: passwd}, function callback(err, api) {
    if (err) {
        return console.error(err);
    }
    api.setOptions({selfListen : true});
    /* */
    direct_input.start();
    var stopListening = api.listen( function(err, event) {
        /*    */
        if (err) {
            return console.error(err);
        }
        switch (event.type) {
            case "message":
                /* Print the value of the thread ID. */
                console.log("Just sent a message in thread #"+event.threadID+" by sender #"+event.senderID);
                direct_input.get(["associated_name"], function (error, result) {
                    if (error) {
                        console.log("[ERR] discover-threadIDs - unsupported operation.");
                        return error;
                    }
                    var addedLine = (result.associated_name+","+event.threadID+"\n");
                  /* TODO uncomment the next line to add sender IDs into the conf file...
                   * This will be made final in a future update... */
/*                    var addedLine = (result.associated_name+","+event.senderID+","+event.threadID+"\n");*/
                    fs.appendFileSync(".config", addedLine);
                });
                break;
            case "event":
                console.log(event);
                break;
/*
            default:
                break;
*/
        }
    });
});

