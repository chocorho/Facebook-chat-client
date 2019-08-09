# Facebook-chat-client
A program that will serve as a chat client, though which a user can, using a mobile device (though so far it works on computers), connect, see all Facebook messages for his account, and reply in real time. In effect, a free-software alternative to Facebook messenger.

## Vision
Suppose you have a Linux machine running and a mobile device. The tentative mission is to allow a user to do the following:
*    leave the Linux machine running a script to continually be ready to receive Facebook messages, and, when they are received, to log them in a temporary storage drive;
*    at a given time, use the mobile device to log into the Linux machine using SSH<sup>[1]</sup>;
*    when logged in, run a temporary "client" script to check for any/all message updates for the chat stream with that person;
*    and, finally, be able to send and receive updates to the message stream in real-time (or something approaching real-time).

<sup>[1]</sup> There are multiple SSH clients available, at least for Android devices. I would suggest 'Mobile SSH', which requires no additional permissions into your device's files, camera, microphone, etc.

## Benefits of Using this Client
*    For as long as the server script runs, you can see any and all messages sent by your Facebook friends, without seeing any of the inflammatory, confusing, or jealousy-inducing posts on Facebook.
*    These scripts can be run at any bash terminal, provided Node.js is installed. Thus, they can be run from any GNU/Linux machine, even one that doesn't have a browser installed, or one that doesn't have X11 installed.
*    You can read messages without them being 'marked as read' in a chat group / thread.
*    You can use this program to chat with friends, without seeing unwanted content on Facebook.

## Requirements Met
*    Provide a way for the user to enter his/her message into a text editor before sending

## Remaining / future requirements
*    Provide a mechanism for checking the config file for inconsistency within it [may take some time to implement]
*    Allow for processing group threads easily (and conveniently printing who said which message)
     *    Update: it turns out, for one-on-one (non-group) chat threads, the threadID matches the senderID.
*    Include a mechanism for point-to-point encryption using PGP (wouldn't THAT be cool?) [will take a bit of time]

## Scripts
*    **launch-server.sh**: the server script, which needs to be running continually in order to receive new messages using this program
*    **check-messages.sh**: the client program, the main program in development. Will authenticate a Facebook account and provide a interactive way to send and receive messages from command-line in real-time.
*    **simple-send-script**: a simple component (originally used for debugging) that allows sending a single message.

## Dependencies
Note that this entire project relies upon Schmavery's Facebook chat API. You can see this unofficial project here: https://github.com/Schmavery/facebook-chat-api.

## Installation

After downloading the files, a user can type:

`npm install`

First, if necessary, make sure each shell script is executable:

`chmod +x *.sh`

Then proceed with automatic or manual configuration (so far, these options aren't that different from each other, unless/until I get a graphical interface working).

## Troubleshooting
You may need to update to the bleeding-edge version of Schmavery's chat API in order for the system to function.

### Automatic configuration
In order to configure this program, run **./install.sh** or **./configure.sh**. Then enter your facebook email and password (this should be secure as is; let me know of any security vulnerabilities). Then you can have the script continue to run as you type in existing chat threads, and the program will inquire as to what you want to name each chat thread.

Alternatively, you can edit the .config file manually.

### Manual configuration
Each Facebook chat thread has a unique thread ID. 
Add these numbers into *your personal* .config file, which is in effect a database, or hash table specifying how to interpret the name of each Facebook friend. 
(Ideally you should keep this config file private; thus for developers it has been added to the .gitignore.) 
It will consist of lines each containing: 

[user-specified name],[threadID]

Using this design, when running the client script from SSH, you don't need to worry about memorizing any lengthy numbers, but there is a guarantee that typing in a name always grants access to the chat thread that you want (the one you configured). This is an advantage over the "Messer" command-line messenger.

To give suggestions, send `chocorho` a message or email.

