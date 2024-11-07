import 'package:flutter/material.dart';
import 'usersList.dart';


class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Функции Администратора'),
      ),
      body: ListView(
        children: [
          
        ],
      ),
      
      );
          
    
  }
}