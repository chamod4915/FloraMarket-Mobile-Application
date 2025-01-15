import 'package:flowersell/admin/OrderDetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewAllOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Orders',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF2F4F3),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
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
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var order =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              var orderId = snapshot.data!.docs[index].id;

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade100,
                    child:
                        Icon(Icons.local_florist, color: Colors.teal.shade700),
                  ),
                  title: Text(
                    order['productName'] ?? 'No Product Name',
                    style: TextStyle(
                      color: Colors.teal.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6),
                      Text(
                        'Customer: ${order['customerName']}',
                        style: TextStyle(
                            color: Colors.teal.shade600, fontSize: 14),
                      ),
                      Text(
                        'Address: ${order['customerAddress']}',
                        style: TextStyle(
                            color: Colors.teal.shade600, fontSize: 14),
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(
                                color: Colors.teal.shade700, fontSize: 14),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order['status']),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              order['status'] ?? 'Pending',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: Colors.teal.shade700),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OrderDetailScreen(orderId: orderId),
                    ));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Processing':
        return Colors.orange.shade400;
      case 'Shipped':
        return Colors.blue.shade400;
      case 'Delivered':
        return Colors.green.shade400;
      case 'Cancelled':
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }
}
