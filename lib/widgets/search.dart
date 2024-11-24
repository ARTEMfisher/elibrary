import 'package:elibrary/widgets/bookinfo.dart';
import 'package:flutter/material.dart';
import 'package:elibrary/routes.dart';
import 'package:elibrary/api.dart';
import 'package:elibrary/variables.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: <Widget>[
          const Expanded(child: SearchBar()),
          PopupMenuButton<int>(
            onSelected: (value) {
              if (value == 0) {
                Navigator.pushNamed(context, AppRoutes.user);
              } else if (value == 1) {
                Navigator.pushNamed(context, AppRoutes.admin);
              }
            },
            itemBuilder: (context) {
              // Создаем список элементов меню
              List<PopupMenuEntry<int>> menuItems = [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text('Аккаунт'),
                ),
              ];

              // Условно добавляем элемент для админа
              if (isAdmin) {
                menuItems.add(const PopupMenuItem<int>(
                  value: 1,
                  child: Text('Админ'),
                ));
              }

              return menuItems;
            },
            icon: const Icon(Icons.perm_identity),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  List<dynamic> _searchResults = [];

  void _searchBooks(String query) async {
    if (query.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final response = await searchBooks(query);
      setState(() => _searchResults = response);
      _showSearchResults(context, _searchResults);
    } catch (e) {
      setState(() => _searchResults = []);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка поиска: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSearchResults(BuildContext context, List<dynamic> results) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.8,
          minChildSize: 0.4,
          builder: (context, scrollController) {
            return ListView.builder(
              controller: scrollController,
              itemCount: results.length,
              itemBuilder: (context, index) {
                final book = results[index];
                return ListTile(
                  onTap: (){
                    showDialog(context: context, 
                    builder: (context) => BookInfo(name: book['title'], author: book['author'], isFree: book['isFree'], imageURL: book['image_url'], bookId: book['id'],));
                  },
                  title: Text(book['title']),
                  subtitle: Text(book['author']),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: _controller,
                  onSubmitted: _searchBooks,
                  decoration: const InputDecoration(
                    hintText: 'Поиск...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isLoading) const LinearProgressIndicator(),
      ],
    );
  }
}
