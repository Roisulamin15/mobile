import 'package:flutter/material.dart';
import 'register_screen.dart'; // Import file register_screen.dart
import 'halaman_login_screen.dart'; // Import file halaman_login_screen.dart

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Menambahkan BoxDecoration untuk gradasi latar belakang
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB3E5FC),
              Color(0xFF0288D1),
            ], // Gradasi warna biru
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        // Menggunakan MediaQuery untuk memastikan container mengisi seluruh layar
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Menambahkan Column untuk menata tombol dan gambar
            Align(
              alignment: Alignment.center, // Menyelaraskan konten ke tengah
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Gambar Ikon
                  Image.asset(
                    'assets/icon-ikan.png', // Ganti dengan path gambar yang sesuai
                    height: 300,
                    width: 300,
                  ),
                  SizedBox(height: 40),
                  // Tombol Login
                  ElevatedButton(
                    onPressed: () {
                      // Aksi untuk menuju ke HalamanLoginScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HalamanLoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(40), // Radius sudut 40
                      ),
                      minimumSize: Size(294, 55), // Lebar 294 dan tinggi 55
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24, // Ukuran font 24
                        color: Colors.white, // Warna font putih
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Tombol Sign Up
                  ElevatedButton(
                    onPressed: () {
                      // Navigasi ke halaman RegisterScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(40), // Radius sudut 40
                      ),
                      minimumSize: Size(294, 55), // Lebar 294 dan tinggi 55
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 24, // Ukuran font 24
                        color: Colors.white, // Warna font putih
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            // Teks "Continue as guest" pada posisi tertentu
            Positioned(
              bottom: 40, // Posisi Y pada bagian bawah
              left: 0,
              right: 0,
              child: Center(
                child: TextButton(
                  onPressed: () {
                    // Aksi untuk lanjut sebagai tamu
                  },
                  child: Text(
                    'Continue as guest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
