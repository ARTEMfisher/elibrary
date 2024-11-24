import 'package:flutter/material.dart';
import 'variables.dart';
import 'api.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<List<dynamic>> _requests;

  @override
  void initState() {
    super.initState();
    _requests = fetchUserRequestsByID(id); 
  }

  Future<void> _refreshRequests() async {
    setState(() {
      _requests = fetchUserRequestsByID(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Страница пользователя'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshRequests, 
        child: FutureBuilder<List<dynamic>>(
          future: _requests,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No requests found.'));
            } else {
              final requests = snapshot.data!;
              return ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[requests.length-index-1];
                  return Card(
                    child: ListTile(
                      onTap: (){
                        if(request['status'] == null || request['status'] == false){
                          showDialog(context: context, builder: (context)=>
                          AlertDialog.adaptive(
                            title:const Text('Вы пока не можете выполнить действий'),
                            actions: [ElevatedButton(onPressed: (){
                              Navigator.pop(context);
                            }, child:const Text('Ок'))
                          ],
                          )
                          );
                        }else{
                          showDialog(context: context, builder: (context)=>
                          AlertDialog.adaptive(
                            title: const Text('Вы уверены что хотите вернуть книгу?'),
                            actions: [ElevatedButton(onPressed: (){
                              Navigator.pop(context);
                            }, child: const Text('Нет')),
                            ElevatedButton(onPressed: (){
                              returnBook(request['id'], id,request['book_id']);
                              Navigator.pop(context);
                            }, child: const Text('Да'))
                          ],
                          )
                          );
                          
                        }
                      },                     
                      title: RichText(
                        text: TextSpan(
                          text: '${request['book_title']} \nСтатус заявки: ',
                          children: <TextSpan>[
                            TextSpan(
                              text: request['status'] == null
                                  ? 'Рассматривается'
                                  : (request['status'] == true
                                      ? 'Подтверждена'
                                      : 'Отказано'),
                              style: TextStyle(
                                color: request['status'] == null
                                    ? Colors.orange
                                    : (request['status'] == true
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
                },
              );
            }
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
