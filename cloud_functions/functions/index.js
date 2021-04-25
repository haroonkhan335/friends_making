const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

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

exports.copyPostsFromFollowing = functions.database.ref('/user/{userId}/followings')
    .onUpdate(async (change, context) => {

        const userId = context.params.userId;
        functions.logger.info('USER ID' + userId);

        const userData = (await admin.database().ref().child('user').child(userId).get()).val();
        const followingId = userData.followings[userData.followings.length - 1];
        try {
            const followingUserData = (await admin.database().ref().child('user').child(followingId).get()).val();
            var addedPosts = [];
            if (userData.posts != null) {
                for (var i = 0; i < userData.posts.length; i++) {
                    addedPosts.push(String(userData.posts[i]));
                }
            } else {
                console.log("USER POSTS NULL");
            }
            if (followingUserData.posts != null) {
                for (var i = 0; i < followingUserData.posts.length; i++) {
                    console.log("ID " + followingUserData.posts[i]);
                    addedPosts.push(String(followingUserData.posts[i]));
                }
            } else {
                console.log("FOLLOWING USER POSTS NULL!!!");
            }

            await admin.database().ref().child('user').child(userId).update({ "posts": addedPosts });

        } catch (e) {
            functions.logger.error("ERROR === " + e);
        }
        return;
    });
