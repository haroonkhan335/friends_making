import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:friends_making/src/auth/controllers/authController.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLoginButtons {
  static final _firestore = FirebaseFirestore.instance;
  static final _firebaseAuth = FirebaseAuth.instance;
  static AuthorizationCredentialAppleID authorizationCredentialAppleID;

  static final double height = 44;
  static final _appleIconSizeScale = 28 / 44;
  static final fontSize = height * 0.43;
  static final AuthController authController = Get.find();

  // static Widget apple({String city, String directions, double latitude, double longitude}) => SignInWithAppleButton(
  //       iconAlignment: IconAlignment.left,
  //       onPressed: () async {
  //         try {
  //           authorizationCredentialAppleID = await SignInWithApple.getAppleIDCredential(
  //             scopes: [
  //               AppleIDAuthorizationScopes.email,
  //               AppleIDAuthorizationScopes.fullName,
  //             ],
  //           );
  //           final oauthCredential = OAuthProvider("apple.com").credential(
  //             idToken: authorizationCredentialAppleID.identityToken,
  //           );
  //           final fbUser = (await _firebaseAuth.signInWithCredential(oauthCredential)).user;
  //           final givenName = authorizationCredentialAppleID.givenName;
  //           print('GIVEN NAME::: $givenName');

  //           final userData = {
  //             "uid": fbUser.uid,
  //             "displayName": givenName,
  //             "photoUrl": "",
  //             "email": authorizationCredentialAppleID.email ?? '',
  //             "emailVerified": true,
  //             "phoneNumber": "",
  //             "isAnonymous": true,
  //             "tenantId": "",
  //             "lastLoginAt": DateTime.now(),
  //             "createdAt": DateTime.now(),
  //             "city": city,
  //             "directions": authController.address.addressLine ?? '',
  //             "latitude": authController.latitude ?? '',
  //             "longitude": authController.longitude ?? '',
  //             "cityCode": authController.address.locality ?? '',
  //             "firstName": givenName ?? '',
  //             "lastName": givenName ?? '',
  //             "haveCompletedData": false,
  //             "middleInitial": givenName ?? "",
  //             "secondLastName": "",
  //             "drivingLicense": ""
  //           };

  //           //TODO: remove later after fixing Apple Authentication
  //           // final firebaseUser = UserModel.User.fromJson(
  //           //     (await _firestore.collection('users').doc('56I8f8w7n5VC35ZepuizlqpjhH02').get()).data());
  //           // await authController.signInWithApple(firebaseUser);
  //           await _firestore.collection('users').doc(fbUser.uid).set(userData);
  //           await authController.signInWithApple(UserModel.User.fromJson(userData));
  //         } on SignInWithAppleAuthorizationException catch (e, s) {
  //           switch (e.code) {
  //             case AuthorizationErrorCode.canceled:
  //               print('CANCELED');
  //               return;
  //               break;
  //             case AuthorizationErrorCode.failed:
  //               print('FAILED');
  //               return;
  //               break;
  //             case AuthorizationErrorCode.invalidResponse:
  //               print('INVALID RESPONSE');
  //               return;
  //               break;
  //             case AuthorizationErrorCode.notHandled:
  //               print('NOT HANDLED');
  //               return;
  //               break;
  //             case AuthorizationErrorCode.unknown:
  //               print('UNKNOWN');
  //               Fluttertoast.showToast(msg: 'Unknown exception by Apple!');
  //               return;
  //               break;
  //             default:
  //               print('DEFAULT');
  //           }
  //         }

  //         // print('AUTHORIZATION CODE ${authorizationCredentialAppleID.authorizationCode}');

  //         // print('APPLE ID CREDENTIALS:::: $authorizationCredentialAppleID');
  //         // final oAuthProvider = OAuthProvider('apple.com');

  //         // final credential = oAuthProvider.credential(
  //         //   idToken: authorizationCredentialAppleID.identityToken,
  //         //   accessToken: authorizationCredentialAppleID.authorizationCode,
  //         // );
  //         // await FirebaseAuth.instance.signInWithCredential(credential);
  //         // print(credential);
  //       },
  //     );
  static Widget facebook = GestureDetector(
      onTap: () async {
        // await authController.signInWithFacebook(authController);
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Color(0xFF3E5994),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black26, offset: Offset(2, 3), blurRadius: 3),
          ],
        ),
        child: Center(
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.0),
                child: Image(
                  image: AssetImage('assets/facebook-white-icon.png'),
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
              ),
              Text('Sign in with Facebook',
                  style: TextStyle(
                      fontSize: height * 0.43, fontFamily: '.SF Pro Text', letterSpacing: -0.41, inherit: false))
            ],
          ),
        ),
      ));
  static Widget google = GestureDetector(
      onTap: () async {
        // if (authController.locationService == false) {
        //   await authController.signInWithGoogle(city: "", directions: "", latitude: 0.0, longitude: 0.0);
        // } else {
        //   await authController.signInWithGoogle(
        //       city: authController.address.locality,
        //       directions: authController.address.addressLine,
        //       latitude: authController.latitude,
        //       longitude: authController.longitude);
        // }
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black26, offset: Offset(2, 3), blurRadius: 3),
          ],
        ),
        child: Center(
          child: Row(
            children: [
              IntrinsicHeight(
                child: Container(
                  color: Colors.white,
                  height: height,
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Image(
                    image: AssetImage('assets/google-logo-ios.png'),
                    height: 18,
                    width: 18,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: 5),
              Text('Sign in with Google',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.43,
                      fontFamily: '.SF Pro Text',
                      letterSpacing: -0.41,
                      inherit: false))
            ],
          ),
        ),
      ));
  // static Widget apple = Container(
  //   height: height,
  //   decoration: BoxDecoration(
  //     color: Colors.black,
  //     boxShadow: [
  //       BoxShadow(color: Colors.grey, offset: Offset(3, 3), blurRadius: 3),
  //       BoxShadow(color: Colors.grey, offset: Offset(-3, 3), blurRadius: 3),
  //       BoxShadow(color: Colors.grey, offset: Offset(3, -3), blurRadius: 3),
  //       BoxShadow(color: Colors.grey, offset: Offset(-3, -3), blurRadius: 3),
  //     ],
  //     borderRadius: BorderRadius.circular(8),
  //   ),
  //   child: Center(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         appleIcon,
  //         SizedBox(width: 10),
  //         Text('Sign in with Apple',
  //             style:
  //                 TextStyle(fontSize: height * 0.43, fontFamily: '.SF Pro Text', letterSpacing: -0.41, inherit: false))
  //       ],
  //     ),
  //   ),
  // );

  static final appleIcon = Container(
    width: _appleIconSizeScale * height,
    height: _appleIconSizeScale * height + 2,
    padding: EdgeInsets.only(
      // Properly aligns the Apple icon with the text of the button
      bottom: (4 / 44) * height,
    ),
    child: Center(
      child: Container(
        width: fontSize * (25 / 31),
        height: fontSize,
        child: CustomPaint(
          painter: AppleLogoPainter(
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
