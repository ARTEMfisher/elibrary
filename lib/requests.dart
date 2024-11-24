import 'package:flutter/material.dart';
import 'api.dart';
import 'dart:async';

class RequestsList extends StatefulWidget {
  const RequestsList({Key? key}) : super(key: key);

  @override
  _RequestsListState createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  late Future<List<dynamic>> requestsFuture;

  @override
  void initState() {
    super.initState();
    _refreshRequests();
  }

  Future<void> _refreshRequests() async {
    setState(() {
      requestsFuture = fetchRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requests List'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshRequests,
        child: FutureBuilder<List<dynamic>>(
          future: requestsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Ошибка: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Нет заявок.'));
            }

            final requests = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[requests.length - index - 1];
                final requestId = request['id'];
                final bookId = request['book_id'];
                final userId = request['user_id'];
                final status = request['status'] == null
                    ? 'Рассматривается'
                    : request['status'] == true
                        ? 'Подтверждена'
                        : 'Отказано';

                return FutureBuilder<Map<String, String>?>(
                  future: fetchBookAndUserDetails(bookId, userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Ошибка: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final bookDetails = snapshot.data;
                      final bookTitle =
                          bookDetails?['book_title'] ?? 'Неизвестно';
                      final username =
                          bookDetails?['username'] ?? 'Неизвестный пользователь';

                      return Card(
                        child: ListTile(
                          onTap: () {request['status']??
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Подтвердить заявку?'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      updateRequestStatus(requestId, true);
                                      Navigator.pop(context);
                                      _refreshRequests(); 
                                    },
                                    child: const Text('Подтвердить'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      updateRequestStatus(requestId, false);
                                      Navigator.pop(context);
                                      _refreshRequests(); 
                                    },
                                    child: const Text('Отклонить'),
                                  ),
                                ],
                              ),
                            );
                            if(request['status']!=null){
                              showDialog(
                                context: context,
                                builder: (context)=>
                                AlertDialog(
                                  title: const Text('Заявка уже рассмотрена'),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          title: Text('Книга: $bookTitle'),
                          subtitle: RichText(
                            text: TextSpan(
                              text: 'Пользователь: $username\nСтатус заявки: ',
                              children: <TextSpan>[
                                TextSpan(
                                  text: status,
                                  style: TextStyle(
                                    color: status == 'Рассматривается'
                                        ? Colors.orange
                                        : (status == 'Подтверждена'
                                            ? Colors.green
                                            : Colors.red),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Text('Данные не найдены');
                    }
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshRequests,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
