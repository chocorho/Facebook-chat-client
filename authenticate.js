var login = require("facebook-chat-api");

var email_addr = process.argv[2];
var passwd = process.argv[3];
console.log("\n[Sanity check] Email address read as "+email_addr);

login({ email: email_addr, password: passwd}, function callback(err, api) {
    if (err) {
        console.error(err);
        process.exit(1);
/*        return console.error(err);*/
    }
});
