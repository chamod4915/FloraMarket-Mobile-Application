import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteCategoryScreen extends StatelessWidget {
  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');

  Future<void> _deleteCategory(String categoryId, BuildContext context) async {
    final confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete',
              style: TextStyle(color: Colors.redAccent)),
          content: const Text('Are you sure you want to delete this category?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child:
                  const Text('Yes', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      try {
        await categories.doc(categoryId).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete category: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delete Category',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF2F4F3),
      body: StreamBuilder(
        stream: categories.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
          }

          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            separatorBuilder: (context, index) =>
                Divider(color: Colors.grey.shade300, thickness: 1),
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  title: Text(
                    data['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  subtitle: Text(
                    data['description'],
                    style: TextStyle(color: Colors.teal.shade600),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline,
                        color: Colors.redAccent, size: 28),
                    onPressed: () => _deleteCategory(doc.id, context),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
