import 'package:http/http.dart' as http;
import 'dart:convert';
import 'variables.dart';



Future<bool> checkUser(String username, String password) async {
  final url = Uri.parse('${ip}check_user');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['valid'];
    } else {
      throw Exception('Failed to check user: ${response.statusCode}');
    }
  } catch (e) {
    
    print(e); 
    return false; 
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
    final response = await http.get(Uri.parse('${ip}users'));

    if (response.statusCode == 200) {
      List<dynamic> usersJson = json.decode(response.body);
      return usersJson.map((user) => {'id': user['id'], 'username': user['username']}).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }


  Future<List<dynamic>> searchBooks(String query) async {
    final url = Uri.parse('${ip}search_books?query=$query');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Ошибка при получении данных: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  Future<List<dynamic>> getUserRequests(int userId) async {
    final url = Uri.parse('${ip}user_requests_by_id/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Ошибка при получении данных: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ошибка сети: $e');
    }
  }

  Future<int?> fetchUserId(String username) async {
  String apiUrl = '${ip}get_user_id';

  try {
    final response = await http.get(
      Uri.parse('$apiUrl?username=$username'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      
      return jsonDecode(response.body)['user_id'];
    } else {
      print('Error: ${jsonDecode(response.body)['message']}');
      return null;
    }
  } catch (e) {
    
    print('Error: Failed to connect to the server');
    return null;
  }
}

void getUserIdByUsername(String username) async {
  final _id = await fetchUserId(username);
  id = _id!;
  if (id != null) {
    print('User ID for $username: $id');
  } else {
    print('User not found or error occurred.');
  }
}

Future<Map<String, dynamic>> fetchUserRequests(int userId) async {
  final url = Uri.parse('${ip}user_requests/$userId');
  
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'error': 'Failed to fetch data'};
    }
  } catch (e) {
    return {'success': false, 'error': e.toString()};
  }
}

Future<Map<String, dynamic>> createRequest(int userId, int bookId) async {
  const String apiUrl = '${ip}create_request';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'bookId': bookId,
      }),
    );

    if (response.statusCode == 201) {
      
      return {'success': true, 'data': jsonDecode(response.body)};
    } else {
      
      return {
        'success': false,
        'error': jsonDecode(response.body)['message'] ??
            'Unknown error occurred'
      };
    }
  } catch (e) {
    return {'success': false, 'error': 'Failed to connect to the server'};
  }
}

Future<Map<String, String>?> fetchBookAndUserDetails(int bookId, int userId) async {
  final response = await http.get(
    Uri.parse('${ip}getUserAndBook?book_id=$bookId&user_id=$userId'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return {
      'book_title': data['book_title'],
      'username': data['username'],
    };
  } else {
    return null; 
  }
}

Future<void> updateRequestStatus(int requestId, bool status) async {
  final url = Uri.parse('${ip}update_request_status');
  
  final headers = {
    'Content-Type': 'application/json',
  };

  final body = json.encode({
    'requestId': requestId,
    'status': status,
  });

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('Request status updated: ${responseData}');
    } else {
      print('Error updating request: ${response.body}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}

Future<List<dynamic>> fetchUserRequestsByID(int userId) async {
    final url = Uri.parse('${ip}user_requests_by_id/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load requests');
    }
  }


Future<String?> fetchBookTitle(int bookId) async {
  final url = Uri.parse('${ip}book_title/$bookId');

  try {
    final response = await http.get(url); 
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); 
      return data['title'];
    } else if (response.statusCode == 404) {
      throw Exception('Книга не найдена');
    } else {
      throw Exception('Ошибка сервера: ${response.statusCode}');
    }
  } catch (e) {
    print('Ошибка запроса: $e');
    return null; 
  }
}

Future<void> returnBook(int requestId, int userId, int bookId) async {
  final response = await http.post(
    Uri.parse('${ip}return_book'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'request_id': requestId,
      'user_id': userId,
      'book_id': bookId,
    }),
  );

  if (response.statusCode == 201) {
    print('Book return request added successfully');
  } else {
    print('Error adding return request: ${response.body}');
  }
}

Future<void> updateReturnStatus(int returnId) async {
  final response = await http.put(
    Uri.parse('${ip}update_return_status'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'return_id': returnId,
      'is_returned': true,
    }),
  );

  if (response.statusCode == 200) {
    print('Return status updated');
  } else {
    throw Exception('Failed to update return status');
  }
}


Future<List<Map<String, dynamic>>> fetchBookReturns() async {
  final response = await http.get(Uri.parse('${ip}returns'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data);
  } else {
    throw Exception('Failed to load returns');
  }
}


Future<List<Map<String, dynamic>>> fetchRequests() async {
  final Uri resronse = Uri.parse('${ip}requests');

  try {
    final response = await http.get(resronse);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Ошибка загрузки данных: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Ошибка при выполнении запроса: $e');
  }
}