import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:doctor/home.dart';
import 'package:doctor/login_page.dart';
import 'package:doctor/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyAZh2qQTdFdcVatD23aX5vJoJU9v30QxEA',
      appId: '1:407399252224:android:3645d1208b938d4c8233e5',
      messagingSenderId: '407399252224',
      projectId: 'doctor-25dd5',
      databaseURL: 'https://doctor-25dd5.firebaseio.com',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BiteBooker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login', // Set the initial route
      routes: {
        '/home': (context) => HomePage(),
        '/register': (context) => RegistrationPage(),
        '/login': (context) => LoginPage(), // Define the home route
      },
    );
  }
}
