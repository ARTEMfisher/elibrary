import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user.dart';

String ip = 'http://45.142.122.187:5000/';

Future<bool> checkUser(String username, String password) async {
  final url = Uri.parse('${ip}check_user');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    // Проверяем код статуса ответа
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['valid'];
    } else {
      throw Exception('Failed to check user: ${response.statusCode}');
    }
  } catch (e) {
    // Возвращаем false в случае ошибки
    print(e); // Выводим ошибку в консоль для отладки
    return false; // Или можете пробросить исключение, если это необходимо
  }
}


Future<bool> addUser(String username, String password) async {
  
  final url = Uri.parse('${ip}add_user');

  try{
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    // Проверяем код статуса ответа
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return data['message'];
    } else {
      throw Exception('Failed to add user: ${response.statusCode}');
      
    }

  } catch (e) {
    print(e); 
    return false;}
  
  }

Future<List<Map<String, dynamic>>> fetchUsers() async {
    final response = await http.get(Uri.parse('${ip}get_users'));

    if (response.statusCode == 200) {
      List<dynamic> usersJson = json.decode(response.body);
      return usersJson.map((user) => {'id': user['id'], 'username': user['username']}).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }