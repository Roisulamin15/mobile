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
      home: HalamanLoginScreen(), // Menampilkan LoginScreen sebagai tampilan awal
      debugShowCheckedModeBanner: false, // Menghilangkan debug banner
    );
  }
}
