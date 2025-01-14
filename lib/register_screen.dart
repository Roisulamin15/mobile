import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'halaman_login_screen.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> registerUser(BuildContext context) async {
  if (passwordController.text != confirmPasswordController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Password tidak sama!")),
    );
    return;
  }

  // Validasi email
  if (emailController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Email tidak boleh kosong!")),
    );
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('http://192.168.199.125:3000/routes/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': usernameController.text,
        'email': emailController.text.trim(), // Pastikan email bersih dari whitespace
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registrasi berhasil!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HalamanLoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Registrasi gagal")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Server error: ${response.statusCode}")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Kesalahan koneksi: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB3E5FC),
                  Color(0xFF0288D1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            left: 110,
            top: 170,
            child: Text(
              'Welcome',
              style: TextStyle(
                fontSize: 45,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            left: 123,
            top: 220,
            child: Text(
              'Create your account',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            top: 360,
            child: Column(
              children: [
                inputField('Username', Icons.person, usernameController),
                SizedBox(height: 16),
                inputField('Email', Icons.email, emailController),
                SizedBox(height: 16),
                inputField('Password', Icons.lock, passwordController,
                    obscureText: true),
                SizedBox(height: 16),
                inputField('Confirm Password', Icons.lock,
                    confirmPasswordController,
                    obscureText: true),
              ],
            ),
          ),
          Positioned(
            left: 100,
            top: 700,
            child: ElevatedButton(
              onPressed: () {
                registerUser(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(200, 50),
              ),
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            left: 98,
            top: 760,
            child: Row(
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(color: Colors.white),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HalamanLoginScreen()),
                    );
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget inputField(String hintText, IconData icon,
      TextEditingController controller,
      {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
