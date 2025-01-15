import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderFormScreen extends StatefulWidget {
  final String productName;
  final String productImage;
  final double price;

  OrderFormScreen({
    required this.productName,
    required this.productImage,
    required this.price,
  });

  @override
  _OrderFormScreenState createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();

  Future<void> _placeOrder() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _contactNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    Map<String, dynamic> newOrder = {
      'userId': user?.uid,
      'customerName': _nameController.text,
      'customerAddress': _addressController.text,
      'customerContactNumber': _contactNumberController.text,
      'productName': widget.productName,
      'productPrice': widget.price,
      'orderDate': DateTime.now(),
      'status': 'Processing'
    };

    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');

    try {
      DocumentReference documentRef = await orders.add(newOrder);

      _nameController.clear();
      _addressController.clear();
      _contactNumberController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Order placed successfully! Order ID: ${documentRef.id}')),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order: ${e.message}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while placing the order')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Order'),
        backgroundColor: Colors.teal.shade600,
      ),
      backgroundColor: Color(0xFFF5F5E9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.productImage,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.productName,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.teal.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${widget.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal.shade600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            buildTextField('Name', _nameController),
            SizedBox(height: 10),
            buildTextField('Address', _addressController),
            SizedBox(height: 10),
            buildTextField('Contact Number', _contactNumberController,
                TextInputType.phone),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal.shade600,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _placeOrder,
              child: Text(
                'Place Order',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller,
      [TextInputType? keyboardType]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.teal.shade800),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal.shade600),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: keyboardType ?? TextInputType.text,
    );
  }
}
