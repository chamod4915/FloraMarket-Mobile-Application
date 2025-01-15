import 'package:flowersell/admin/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF2F4F3), // Light background color for contrast
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            SizedBox(height: 20),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading:
                    Icon(Icons.security, color: Colors.teal.shade700, size: 30),
                title: Text(
                  'Privacy & Security',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.teal.shade800,
                  ),
                ),
                subtitle: Text(
                  'Manage your privacy settings',
                  style: TextStyle(color: Colors.teal.shade600, fontSize: 14),
                ),
                trailing:
                    Icon(Icons.arrow_forward_ios, color: Colors.teal.shade400),
                onTap: () {
                  // Navigate to privacy settings
                },
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.notifications,
                    color: Colors.teal.shade700, size: 30),
                title: Text(
                  'Notifications',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.teal.shade800,
                  ),
                ),
                subtitle: Text(
                  'Customize notification preferences',
                  style: TextStyle(color: Colors.teal.shade600, fontSize: 14),
                ),
                trailing:
                    Icon(Icons.arrow_forward_ios, color: Colors.teal.shade400),
                onTap: () {
                  // Navigate to notification settings
                },
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AdminLogin()),
                );
              },
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
