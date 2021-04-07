import 'package:friends_making/src/auth/screens/authenticationLanding.dart';
import 'package:friends_making/src/auth/screens/loginScreen.dart';
import 'package:friends_making/src/auth/screens/signUpScreen.dart';
import 'package:get/get.dart';

class Pages {
  static final getPages = [
    GetPage(name: '/auth_landing', page: () => AuthenticationLanding()),
    GetPage(name: LOGIN, page: () => LoginScreen()),
    GetPage(name: SIGN_UP, page: () => SignUpScreen()),
  ];

  static const String AUTH_LANDING = '/auth_landing';
  static const String LOGIN = '/login';
  static const String SIGN_UP = '/sign_up';
}
