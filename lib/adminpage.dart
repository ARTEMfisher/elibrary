import 'package:elibrary/routes.dart';
import 'package:flutter/material.dart';



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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ElevatedButton(
              
              onPressed: (){
                Navigator.pushNamed(context, AppRoutes.usersList);
              },
              child: Text('Пользователи'),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, AppRoutes.requests);
              },
              child: Text('Заявки'),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, AppRoutes.returns);
              },
              child: Text('Возвраты'),
            ),
          ],
        ),
      ),
      
      );
          
    
  }
}