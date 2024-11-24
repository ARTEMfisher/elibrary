import 'package:flutter/material.dart';
import 'api.dart';

class BookReturnsPage extends StatefulWidget {
  const BookReturnsPage({Key? key}) : super(key: key);

  @override
  _BookReturnsPageState createState() => _BookReturnsPageState();
}

class _BookReturnsPageState extends State<BookReturnsPage> {
  late Future<List<Map<String, dynamic>>> _bookReturns;

  @override
  void initState() {
    super.initState();
    _bookReturns = fetchBookReturns(); 
  }

  void _refreshData() {
    setState(() {
      _bookReturns = fetchBookReturns(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список возвратов'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData, 
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( 
        future: _bookReturns,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет возвратов'));
          } else {
            final bookReturns = snapshot.data!;
            return ListView.builder(
              itemCount: bookReturns.length,
              itemBuilder: (context, index) {
                final bookReturn = bookReturns[bookReturns.length-index-1];
                final bookId = bookReturn['book_id']; 

                return FutureBuilder<String?>(
                  future: fetchBookTitle(bookId),
                  builder: (context, titleSnapshot) {
                    if (titleSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (titleSnapshot.hasError) {
                      return ListTile(
                        title: const Text('Ошибка загрузки названия книги'),
                        subtitle: Text('Статус возврата: ${bookReturn['is_returned'] ? "Возвращена" : "Не возвращена"}'),
                      );
                    } else if (!titleSnapshot.hasData || titleSnapshot.data == null) {
                      return ListTile(
                        title: const Text('Название книги не найдено'),
                        subtitle: Text('Статус возврата: ${bookReturn['is_returned'] ? "Возвращена" : "Не возвращена"}'),
                      );
                    } else {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            showDialog(context: context, 
                            builder:(context)=>AlertDialog(
                              title:const Text('Вы уверены, что пользователь сдал книгу?'),
                              actions: [
                                ElevatedButton(
                                  onPressed: (){
                                    updateReturnStatus(bookReturn['id']);
                                    setState(() {
                                      _refreshData(); 
                                    });
                                  },
                                  child: const Text('Да'),
                                ),
                                ElevatedButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Нет'),
                                ),
                              ],
                            ) );
                            
                          },
                          title: Text('Книга: ${titleSnapshot.data}'), 
                          subtitle: Text('Статус возврата: ${bookReturn['is_returned'] ? "Возвращена" : "Не возвращена"}'),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
