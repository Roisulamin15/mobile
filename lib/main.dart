import 'package:capstonemobile/halaman_login_screen.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart'; // Mengimpor file login_screen.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budidaya Ikan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Menambahkan route untuk halaman login
      initialRoute: '/login', // Set halaman awal menggunakan '/login'
      routes: {
        '/login': (context) => HalamanLoginScreen(), // Menambahkan route untuk halaman login
        // Bisa menambahkan route lainnya di sini
      },
      debugShowCheckedModeBanner: false, // Menghilangkan debug banner
    );
  }
}
