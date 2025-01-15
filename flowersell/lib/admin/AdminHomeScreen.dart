import 'package:flowersell/admin/AddProductScreen.dart';
import 'package:flowersell/admin/DeleteCategoryScreen.dart';
import 'package:flowersell/admin/account.dart';
import 'package:flowersell/admin/category.dart';
import 'package:flowersell/admin/order.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _adminScreens = [
    AddProductScreen(),
    AddCategoryScreen(),
    ViewAllOrdersPage(),
    DeleteCategoryScreen(),
    Logout()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _adminScreens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Add Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete),
            label: 'Delete Category',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 225, 232, 239),
        unselectedItemColor: Color.fromARGB(255, 151, 203, 245),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(255, 32, 124, 167),
      ),
    );
  }
}
