import 'package:flutter/material.dart';
import 'adminpage.dart';
import 'auth.dart';
import 'mainpage.dart';
import 'reg.dart';
import 'userpage.dart';
import 'usersList.dart';
import 'userInfo.dart';
import 'requests.dart';
import 'returns.dart';


class AppRoutes{

  static const String main = '/';
  static const String auth = '/auth';
  static const String reg = '/reg';
  static const String admin = '/admin';
  static const String user = '/user';
  static const String usersList = '/usersList';
  static const String userInfo = '/userInfo';
  static const String requests = '/requests';
  static const String returns = '/return';

  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case main:
        return MaterialPageRoute(builder: (_)=> MainPage());
      case auth:
        return MaterialPageRoute(builder: (_)=> Authorise());
      case reg:
        return MaterialPageRoute(builder: (_)=> Registration());
      case admin:
        return MaterialPageRoute(builder: (_)=> AdminPage());
      case user:
        return MaterialPageRoute(builder: (_)=> UserPage());
      case usersList:
        return MaterialPageRoute(builder: (_)=> UsersList());
      case userInfo:
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => UserInfo(
          username: args['username'],
          userId: args['userId'],
        ),
      );
      case requests:
        return MaterialPageRoute(builder: (_)=> RequestsList());
      case returns:
        return MaterialPageRoute(builder: (_)=> BookReturnsPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Страница не найдена'),
            ),
          ),);
    }
  }

}

