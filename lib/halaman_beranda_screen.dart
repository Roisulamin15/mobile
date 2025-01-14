import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'deteksi_ikan_screen.dart';
import 'deteksi_kolam_screen.dart';
import 'penyakit_ikan_screen.dart';
import 'profile_screen.dart';
import 'chatbot_screen.dart';
import 'sentimen_screen.dart';

class HalamanBerandaScreen extends StatefulWidget {
  @override
  _HalamanBerandaScreenState createState() => _HalamanBerandaScreenState();
}

class _HalamanBerandaScreenState extends State<HalamanBerandaScreen> {
  String username = '';
  String email = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi untuk memuat data user dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Coba load username yang disimpan pertama
    String loadedUsername = prefs.getString('username') ?? '';
    
    // Jika username kosong atau 'N/A', coba ambil entered_username
    if (loadedUsername.isEmpty || loadedUsername == 'N/A') {
      loadedUsername = prefs.getString('entered_username') ?? 'Tidak ada username';
    }

    // Update state untuk menampilkan data yang sudah diambil
    setState(() {
      username = loadedUsername;
      email = prefs.getString('email') ?? 'Tidak ada email';
      token = prefs.getString('token') ?? '';
    });

    print('Beranda - Username loaded: $username');
    print('Beranda - Email loaded: $email');
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text(
          'Selamat datang, $username',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB3E5FC), Color(0xFF0288D1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/budidaya.png',
                      width: 300,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMenuCard(
                        'Deteksi Ikan',
                        'assets/fish 1.png',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DeteksiIkanScreen()),
                        ),
                      ),
                      _buildMenuCard(
                        'Deteksi Kolam',
                        'assets/sea 1.png',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DeteksiKolamScreen()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PenyakitIkanScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(200, 50),
                    ),
                    child: Text(
                      'Info Penyakit',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.black),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics, color: Colors.black),
            label: 'Sentimen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatbotScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SentimenScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  username: username,
                  email: email,
                  token: token,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMenuCard(String title, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 135,
            height: 135,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
