import 'package:elibrary/routes.dart';
import 'package:flutter/material.dart';
import 'variables.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Страница пользователя'),
      ),
      body: auth?
      Center(child: Text('You authorised'),) :
      Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Для просмотра страницы авторизуйтесь'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.auth);
                },
                child: const Text('Войти'),
              ),
            ],
          )
          ),
        ),
    );
  }
}