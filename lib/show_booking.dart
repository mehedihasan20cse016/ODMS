import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShowBookingPage extends StatelessWidget {
  final String? userEmail;

  ShowBookingPage({this.userEmail});

  // Function to delete a booking
  void deleteBooking(String bookingId) {
    FirebaseFirestore.instance
        .collection('booking')
        .doc(bookingId)
        .delete()
        .then((value) => print('Booking deleted'))
        .catchError((error) => print('Failed to delete booking: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('booking')
            .where('user_email', isEqualTo: userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No bookings found'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var booking =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>?;

              // Check if booking is not null and has required fields
              if (booking == null ||
                  !booking.containsKey('doctor_id') ||
                  !booking.containsKey('date') ||
                  !booking.containsKey('time')) {
                return SizedBox(); // Or handle null case as per your requirement
              }

              String bookingId = snapshot.data!.docs[index].id;
              String doctorId = booking['doctor_id'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('manage_doctors')
                    .doc(doctorId)
                    .get(),
                builder: (context, doctorSnapshot) {
                  if (doctorSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (doctorSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${doctorSnapshot.error}'));
                  }
                  if (!doctorSnapshot.hasData ||
                      doctorSnapshot.data == null ||
                      !doctorSnapshot.data!.exists) {
                    return Center(child: Text('Doctor details not found'));
                  }

                  var doctorData =
                      doctorSnapshot.data!.data() as Map<String, dynamic>?;

                  // Check if doctorData is not null before accessing its fields
                  if (doctorData == null) {
                    return Center(child: Text('Doctor details not found'));
                  }

                  String doctorName = doctorData['name'] ?? 'No name available';
                  String doctorImage = doctorData['image_url'] ??
                      'https://via.placeholder.com/150';

                  return Card(
                    elevation: 5,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(doctorImage),
                      ),
                      title: Text(doctorName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${booking['date']}'),
                          Text('Time: ${booking['time']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm Deletion'),
                                content: Text(
                                    'Are you sure you want to delete this booking?'),
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
                                      deleteBooking(bookingId);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
