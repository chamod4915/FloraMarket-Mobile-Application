import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewOrdersScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Please log in to view orders.',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
        backgroundColor: Colors.teal.shade700,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.teal.shade700,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error fetching orders: ${snapshot.error}',
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No orders found',
                style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var orderData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Order ID: ${snapshot.data!.docs[index].id}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade900,
                        ),
                      ),
                      Divider(color: Colors.teal.shade100),
                      buildOrderDetailText(
                          'Product Name: ${orderData['productName']}'),
                      buildOrderDetailText(
                          'Price: \$${orderData['productPrice']}'),
                      buildOrderDetailText(
                          'Address: ${orderData['customerAddress']}'),
                      buildOrderDetailText(
                          'Contact: ${orderData['customerContactNumber']}'),
                      SizedBox(height: 10),
                      Text(
                        'Status: ${orderData['status']}',
                        style: TextStyle(
                          color: orderData['status'] == 'Delivered'
                              ? Colors.green
                              : Colors.orangeAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildOrderDetailText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
