import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  OrderDetailScreen({required this.orderId});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String? currentStatus;
  final List<String> statuses = [
    'Pending',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled'
  ];

  @override
  void initState() {
    super.initState();
    _fetchCurrentStatus();
  }

  void _fetchCurrentStatus() async {
    DocumentSnapshot orderSnapshot = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .get();
    if (orderSnapshot.exists) {
      setState(() {
        currentStatus = orderSnapshot['status'] as String? ?? statuses.first;
      });
    }
  }

  void _updateStatus(String? newStatus) async {
    if (newStatus == null || newStatus == currentStatus) return;

    await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .update({
      'status': newStatus,
    });
    setState(() {
      currentStatus = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Order Status'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: currentStatus == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                value: currentStatus,
                onChanged: _updateStatus,
                items: statuses.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
