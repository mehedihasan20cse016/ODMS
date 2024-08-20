import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import for Firebase Authentication
import 'package:url_launcher/url_launcher.dart';
import 'booking_page.dart'; // Import the booking page

class DetailsDoctorPage extends StatelessWidget {
  final String doctorId;

  DetailsDoctorPage({required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('manage_doctors')
            .doc(doctorId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var doctor = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(doctor['image_url']),
                  ),
                ),
                SizedBox(height: 16),
                _buildDetailCard(
                  icon: Icons.person,
                  color: Colors.blue,
                  title: 'Name',
                  content: doctor['name'],
                ),
                _buildDetailCard(
                  icon: Icons.cake,
                  color: Colors.pink,
                  title: 'Age',
                  content: doctor['age'].toString(),
                ),
                _buildDetailCard(
                  icon: Icons.email,
                  color: Colors.green,
                  title: 'Email',
                  content: doctor['email'],
                ),
                _buildDetailCard(
                  icon: Icons.description,
                  color: Colors.orange,
                  title: 'Description',
                  content: doctor['description'],
                ),
                _buildDetailCard(
                  icon: Icons.attach_money,
                  color: Colors.red,
                  title: 'Service Charge',
                  content: doctor['service_charge'].toString(),
                ),
                _buildDetailCard(
                  icon: Icons.access_time,
                  color: Colors.purple,
                  title: 'Service Time',
                  content: doctor['service_time'],
                ),
                _buildDetailCard(
                  icon: Icons.local_hospital,
                  color: Colors.teal,
                  title: 'Specialty',
                  content: doctor['specialist_in'],
                ),
                _buildDetailCard(
                  icon: Icons.phone,
                  color: Colors.blueGrey,
                  title: 'Phone',
                  content: doctor['phone'],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.call),
              color: Colors.green,
              onPressed: () async {
                var snapshot = await FirebaseFirestore.instance
                    .collection('manage_doctors')
                    .doc(doctorId)
                    .get();
                var doctor = snapshot.data() as Map<String, dynamic>;
                _launchCaller(doctor['phone']);
              },
            ),
            IconButton(
              icon: Icon(Icons.book_online),
              color: Colors.blue,
              onPressed: () async {
                try {
                  // Fetch the currently logged in user's email
                  var user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    var userEmail = user.email;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingPage(
                          doctorId: doctorId,
                          userEmail: userEmail!,
                        ),
                      ),
                    );
                  } else {
                    throw 'User not logged in';
                  }
                } catch (e) {
                  print("Error fetching user email: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to navigate to booking page.'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(
      {required IconData icon,
      required Color color,
      required String title,
      required String content}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _launchCaller(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
