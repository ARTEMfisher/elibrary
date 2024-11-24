import 'package:flutter/material.dart';
import 'package:elibrary/routes.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
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
      
    );
  }
}