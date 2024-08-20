import 'package:flutter/material.dart';
import 'manage_doctor_page.dart';
import 'login_page.dart';
import 'manageUser.dart'; // Import your login page here

class ManageDatabasePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Database'),
        automaticallyImplyLeading: false, // Remove back button
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Navigate to login page on logout
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginPage()), // Replace with your login page widget
                (route) =>
                    false, // Prevent user from going back to previous screens
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageDoctorPage()),
                );
              },
              child: Text('Manage Doctors'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageUserPage()),
                );
              },
              child: Text('Manage Users'),
            ),
          ],
        ),
      ),
    );
  }
}
