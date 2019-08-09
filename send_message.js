var login = require("facebook-chat-api");

var email_addr = process.argv[2];
var passwd = process.argv[3];
var id  = process.argv[4];
var payload  = process.argv[5];

/*
if (email_addr.endsWith("\n")) {
    console.log("Replacing "+email_addr+" with:");
    email_addr = email_addr.substr(0, email_addr.length-1);
    console.log("[new]"+email_addr);
}

if (passwd.endsWith("\n")) {
    passwd = passwd.substr(0, passwd.length-1);
}

if (payload.endsWith("\n")) {
    console.log("Replacing "+payload+" with "+payload);
    payload = payload.substr(0, payload.length-1);
    console.log("[new]"+payload);
}

console.log("\n[Sanity check] Email address read as "+email_addr);
console.log("\n[Sanity check] id taken as "+id);
console.log("\n[Sanity check] Payload read as "+payload);
*/

login({ email: email_addr, password: passwd}, function callback(err, api) {
    if (err) {
        console.log("ERROR LOGGING IN");
        console.error(err);
        process.exit(1);
    }
    api.sendMessage(payload, id);
});
