import 'package:capstonemobile/update_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String email;
  final String token;

  ProfileScreen({
    required this.username,
    required this.email,
    required this.token,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String username;
  late String email;
  late String token;
  String? userId;

  // Fungsi untuk mendecode token JWT dan mengambil ID
  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var resp = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(resp);
    return payloadMap;
  }

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? widget.username;
      email = prefs.getString('email') ?? widget.email;
      token = prefs.getString('token') ?? widget.token;
      
      // Mengambil ID dari token JWT
      try {
        final decodedToken = parseJwt(token);
        userId = decodedToken['id'].toString();
        print('Extracted userId from token: $userId');
      } catch (e) {
        print('Error extracting userId from token: $e');
      }
    });
  }

  // Fungsi untuk memperbarui profil setelah berhasil diperbarui di UpdateProfileScreen
  void updateProfile(String updatedUsername, String updatedEmail) {
    setState(() {
      username = updatedUsername;
      email = updatedEmail;
    });
  }

  Future<void> deleteAccount() async {
    if (userId == null || userId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ID pengguna tidak ditemukan')),
      );
      return;
    }

    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi'),
        content: Text('Apakah Anda yakin ingin menghapus akun ini? (ID: $userId)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final url = 'http://192.168.199.125:3000/routes/login/delete/$userId';
        final response = await http.delete(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Akun berhasil dihapus')),
          );

          await Future.delayed(Duration(seconds: 1));
          
          // Arahkan pengguna ke halaman login setelah penghapusan akun
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login', 
            (Route<dynamic> route) => false, 
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menghapus akun (${response.statusCode}). Mohon cek log untuk detail.'),
              duration: Duration(seconds: 4),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Info Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/profile.jpg'),
                backgroundColor: Colors.transparent,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfileScreen(
                      initialUsername: username,
                      initialEmail: email,
                    ),
                  ),
                ).then((result) {
                  if (result != null) {
                    // Update the profile in ProfileScreen with the new data
                    updateProfile(result['username'], result['email']);
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(150, 45),
              ),
              child: Text(
                'Update Profile',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: deleteAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: Size(150, 45),
              ),
              child: Text(
                'Delete Akun',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 40),
            buildInfoCard(Icons.person, 'Username', username),
            SizedBox(height: 20),
            buildInfoCard(Icons.email, 'Email', email),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800], size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
