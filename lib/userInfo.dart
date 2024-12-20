import 'package:flutter/material.dart';
import 'api.dart'; // Подключение файла с функцией получения заявок

class UserInfo extends StatefulWidget {
  final String username;
  final int userId;

  const UserInfo({
    Key? key,
    required this.username,
    required this.userId,
  }) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  List<dynamic> requests = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserRequestsByID(widget.userId);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchUserRequestsByID(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Запросы не найдены.'));
          } else {
            final requests = snapshot.data!;
            return ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[requests.length-index-1];
                return Card(
                  child: ListTile(
                    title: RichText(
                          text: TextSpan(
                            text: '${request['book_title']} \nСтатус заявки: ',
                            children: <TextSpan>[
                              TextSpan(
                                text: request['status'] == null ? 'Рассматривается' :
                                      (request['status'] == true ? 'Подтверждена' : 'Отказано'),
                                style: TextStyle(
                                  color: request['status'] == null
                                      ? Colors.orange  
                                      : (request['status'] == true ? Colors.green : Colors.red), 
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                );
              },
            );
          }
        },
      ), 
    );
  }
}
