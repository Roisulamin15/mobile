    import 'package:flutter/material.dart';
    import 'package:http/http.dart' as http;
    import 'dart:convert';
    class UpdateProfileScreen extends StatefulWidget {
      final String initialUsername;
      final String initialEmail;

      UpdateProfileScreen({
        required this.initialUsername,
        required this.initialEmail,
      });

      @override
      _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
    }

    class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
      late TextEditingController usernameController;
      late TextEditingController emailController;

      @override
      void initState() {
        super.initState();
        usernameController = TextEditingController(text: widget.initialUsername);
        emailController = TextEditingController(text: widget.initialEmail);
      }

      @override
      void dispose() {
        usernameController.dispose();
        emailController.dispose();
        super.dispose();
      }

      Future<void> saveProfile() async {
        String newUsername = usernameController.text.trim();
        String newEmail = emailController.text.trim();
        String userId = 'ID_PENGGUNA'; // Ganti dengan ID pengguna yang sesuai

        // Validasi input
        if (newUsername.isEmpty || newEmail.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nama pengguna dan email tidak boleh kosong')),
          );
          return;
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(newEmail)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Format email tidak valid')),
          );
          return;
        }

        try {
          final response = await http.put(
            Uri.parse('http://192.168.199.125:3000/routes/profile/update'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'id': 24, // Sertakan ID pengguna di sini
              'username': newUsername,
              'email': newEmail,
            }),
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            if (data['success']) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profil berhasil diperbarui')),
              );
              Navigator.pop(context, {
                'username': newUsername,
                'email': newEmail,
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(data['message'] ?? 'Gagal memperbarui profil')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Kesalahan server: ${response.statusCode}')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kesalahan koneksi: $e')),
          );
        }
    }     
      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Update Profile'),
            backgroundColor: Colors.blue[800],
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama pengguna baru',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Email',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan email baru',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(140, 40),
                    ),
                    child: Text(
                      'Simpan',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
