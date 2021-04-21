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
    return "Hello from Firebase!";
});
