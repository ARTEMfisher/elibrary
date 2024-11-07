import 'package:elibrary/variables.dart';
import 'package:flutter/material.dart';
import 'package:elibrary/routes.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: <Widget>[
          const Expanded(child: SearchBar()), // Адаптируем строку поиска
          PopupMenuButton<int>(
  onSelected: (value) {
    if (value == 0) {
      // Navigator.pushNamed(context, AppRoutes.user);
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

    return menuItems; // Возвращаем список элементов
  },
  icon: const Icon(Icons.perm_identity),
),

        ],
      ),
    );
  }

  // Обязательная реализация для PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // Задаем высоту строки поиска
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Цвет фона для поля поиска
        borderRadius: BorderRadius.circular(25.0), // Округление границ
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey), // Иконка поиска
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              style: const TextStyle(
                color: Colors.black
              ),
              decoration: InputDecoration(
                hintStyle: TextStyle(color: Colors.black),
                hintText: 'Поиск...',
                border: InputBorder.none, // Убираем подчеркивание
              ),
            ),
          ),
        ],
      ),
    );
  }
}
