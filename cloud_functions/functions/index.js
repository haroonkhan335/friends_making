const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions


/* eslint-disable no-unused-vars */
exports.helloWorld = functions.https.onRequest((request, response) => {
    functions.logger.info("Hello logs!", { structuredData: true });

    var someVar = request.app;
    console.log('HELLO WORLD FROM FIRST FUNCTION ');
    response.send("Hello from Firebase!");
});

exports.helloWorldAnother = functions.https.onCall((request, response) => {
    functions.logger.info("Hello logs!", { structuredData: true });
    return { "name": "Haroon", "skill": "Flutter Developer" };
});

exports.test = functions.database.ref('/user/{userId}/followers/{followersId}')
    .o((change, context) => {
        // Grab the current value of what was written to the Realtime Database.
        // const original = snapshot.val();


        const userId = context.params.user;
        const followersId = context.params.followersId;


        change.after.val();
        functions.logger.log('Uppercasing', context.params.pushId, original);
        const uppercase = original.toUpperCase();
        // You must return a Promise when performing asynchronous tasks inside a Functions such as
        // writing to the Firebase Realtime Database.
        // Setting an "uppercase" sibling in the Realtime Database returns a Promise.
        return snapshot.ref.parent.child('uppercase').set(uppercase);
    });
