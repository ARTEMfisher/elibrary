import 'package:flutter/material.dart';
import 'package:elibrary/auth.dart';
import 'package:elibrary/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRoutes.generateRoute,
      initialRoute: AppRoutes.auth,
      debugShowCheckedModeBanner: false,
      theme:ThemeData.dark(),
      //home: Authorise(),
    );
  }
}