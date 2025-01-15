import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategoryScreen extends StatelessWidget {
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryDescriptionController =
      TextEditingController();

  Future<void> _addCategoryToFirestore(BuildContext context) async {
    String categoryName = _categoryNameController.text.trim();
    String categoryDescription = _categoryDescriptionController.text.trim();
    if (categoryName.isNotEmpty && categoryDescription.isNotEmpty) {
      try {
        CollectionReference categories =
            FirebaseFirestore.instance.collection('categories');
        await categories.add({
          'name': categoryName,
          'description': categoryDescription,
        });
        _categoryNameController.clear();
        _categoryDescriptionController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add category: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all the fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Category',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF2F4F3), // Light background color for contrast
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Enter Category Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade900,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _categoryNameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
                labelStyle: TextStyle(color: Colors.teal.shade900),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.teal.shade400),
                ),
                prefixIcon: Icon(Icons.category, color: Colors.teal.shade800),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _categoryDescriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Category Description',
                labelStyle: TextStyle(color: Colors.teal.shade900),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: Colors.teal.shade400),
                ),
                prefixIcon:
                    Icon(Icons.description, color: Colors.teal.shade800),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              child: Text(
                'Add Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal.shade600, // Button text color
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 5,
              ),
              onPressed: () => _addCategoryToFirestore(context),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info, color: Colors.teal.shade400),
                  SizedBox(height: 8),
                  Text(
                    'Tips:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Category names should be unique and descriptive. '
                    'Category descriptions help users understand the contents better.',
                    style: TextStyle(fontSize: 14, color: Colors.teal.shade800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
