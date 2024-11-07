import 'package:elibrary/adminpage.dart';
import 'package:flutter/material.dart';
import 'package:elibrary/auth.dart';
import 'package:elibrary/mainpage.dart';
import 'package:elibrary/reg.dart';
import 'userpage.dart';
import 'usersList.dart';


class AppRoutes{

  static const String main = '/';
  static const String auth = '/auth';
  static const String reg = '/reg';
  static const String admin = '/admin';
  static const String user = '/user';
  static const String usersList = '/usersList';

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

