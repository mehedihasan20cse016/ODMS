import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageUserPage extends StatefulWidget {
  @override
  _ManageUserPageState createState() => _ManageUserPageState();
}

class _ManageUserPageState extends State<ManageUserPage> {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CRUD operations

  // Read operation
  Future<List<DocumentSnapshot>> fetchUsers() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('users_profile').get();
    return querySnapshot.docs;
  }

  // Delete operation
  void deleteUser(String userId) async {
    await _firestore.collection('users_profile').doc(userId).delete();
    setState(() {
      // Update UI as needed after deletion
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No users found'));
          }

          // Display data in a DataTable wrapped in SingleChildScrollView
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Image')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: snapshot.data!.map((DocumentSnapshot document) {
                  Map<String, dynamic> userData =
                      document.data() as Map<String, dynamic>;
                  String userId = document.id;

                  return DataRow(cells: [
                    DataCell(Text(userData['name'] ?? 'No name')),
                    DataCell(Text(userData['email'] ?? 'No email')),
                    DataCell(Text(userData['phone'] ?? 'No phone')),
                    DataCell(
                      userData['image'] != null
                          ? Image.network(userData['image'])
                          : Text('No image'),
                    ),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Implement edit functionality
                            // Example: navigate to edit page
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Deletion'),
                                  content: Text(
                                      'Are you sure you want to delete this user?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        deleteUser(userId);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement create new user functionality
          // Example: navigate to create page
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Manage Users Example',
    home: ManageUserPage(),
  ));
}
