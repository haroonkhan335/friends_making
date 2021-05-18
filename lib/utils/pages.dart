import 'package:friends_making/src/auth/screens/authenticationLanding.dart';
import 'package:friends_making/src/auth/screens/loginScreen.dart';
import 'package:friends_making/src/auth/screens/signUpScreen.dart';
import 'package:friends_making/src/home/screens/comments.dart';
import 'package:friends_making/src/home/widgets/followUsers.dart';
import 'package:friends_making/src/home/widgets/usersToFollow.dart';
import 'package:get/get.dart';

class Pages {
  static final getPages = [
    GetPage(name: '/auth_landing', page: () => AuthenticationLanding()),
    GetPage(name: LOGIN, page: () => LoginScreen()),
    GetPage(name: SIGN_UP, page: () => SignUpScreen()),
    GetPage(name: COMMENTS, page: () => Comments()),
    GetPage(name: FOLLOW_USERS, page: () => FollowUsers()),
    GetPage(name: USERS, page: () => UsersToFollow())
  ];

  static const String AUTH_LANDING = '/auth_landing';
  static const String LOGIN = '/login';
  static const String SIGN_UP = '/sign_up';
  static const String COMMENTS = '/comments';
  static const String FOLLOW_USERS = '/followUsers';
  static const String USERS = '/users';
}
