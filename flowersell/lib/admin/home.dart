import 'package:flowersell/admin/AddProductScreen.dart';
import 'package:flowersell/admin/DeleteCategoryScreen.dart';
import 'package:flowersell/admin/category.dart';
import 'package:flowersell/admin/order.dart';
import 'package:flowersell/admin/login.dart';
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
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          [
            'Add Product',
            'Categories',
            'Orders',
            'Delete Category'
          ][_selectedIndex],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AdminLogin()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFF2F4F3),
      body: IndexedStack(
        index: _selectedIndex,
        children: _adminScreens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete_outline),
            label: 'Delete Category',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal.shade700,
        unselectedItemColor: Colors.grey.shade600,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
