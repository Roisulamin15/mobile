import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'halaman_beranda_screen.dart'; // Import HalamanBerandaScreen

class SentimenScreen extends StatefulWidget {
  @override
  _SentimenScreenState createState() => _SentimenScreenState();
}

class _SentimenScreenState extends State<SentimenScreen> {
  final TextEditingController _sentimenController = TextEditingController();
  String _responseMessage = '';

  Future<void> _submitSentimen() async {
    final sentimen = _sentimenController.text;

    // Ambil email dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? ''; // Pastikan email tidak null

    if (sentimen.isEmpty) {
      setState(() {
        _responseMessage = "Review tidak boleh kosong.";
      });
      return;
    }

    try {
      final url = Uri.parse("http://192.168.199.125:3000/routes/sentimen");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": sentimen}),

      );

      if (response.statusCode == 201) {
  final responseData = jsonDecode(response.body);
  setState(() {
    _responseMessage = responseData['message'];
  });
  _sentimenController.clear(); // Kosongkan input setelah berhasil
} else {
  setState(() {
    _responseMessage =
        "Gagal mengirim review. Kode status: ${response.statusCode}";
  });
}

    } catch (e) {
      setState(() {
        _responseMessage = "Terjadi kesalahan: $e";
      });
    }
  }

  // Membuat custom page route dengan animasi geser dari kanan ke kiri
  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Animasi mulai dari kanan
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: Duration(milliseconds: 400), // Durasi animasi lebih cepat
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Mencegah navigasi kembali dan arahkan ke halaman beranda dengan animasi geser dari kanan ke kiri
        Navigator.pushAndRemoveUntil(
          context,
          _createPageRoute(HalamanBerandaScreen()),
          (Route<dynamic> route) =>
              false, // Menghapus semua halaman sebelumnya dari stack
        );
        return Future.value(false); // Mencegah aksi default tombol back
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          title: Text("Sentimen Review"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigasi ke Halaman Beranda dengan animasi geser dari kanan ke kiri
              Navigator.pushAndRemoveUntil(
              context,
              _createPageRoute(HalamanBerandaScreen()),
              (Route<dynamic> route) => false, // Menghapus semua halaman sebelumnya dari stack
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tulis Review Anda:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _sentimenController,
                decoration: InputDecoration(
                  hintText: "Bagikan pengalaman Anda...",
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitSentimen,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("Kirim Review"),
              ),
              SizedBox(height: 16),
              Text(
                _responseMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}