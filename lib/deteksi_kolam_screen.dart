import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

class DeteksiKolamScreen extends StatefulWidget {
  @override
  _DeteksiKolamScreenState createState() => _DeteksiKolamScreenState();
}

class _DeteksiKolamScreenState extends State<DeteksiKolamScreen> {
  File? _image;
  String? _hasilDeteksi;
  bool _isLoading = false; // Indikator loading

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          _hasilDeteksi = null; // Reset hasil deteksi
        });
      }
    } catch (e) {
      _showDialog('Error', 'Gagal mengambil gambar: $e');
    }
  }

  // Fungsi untuk mengupload gambar ke server dan menampilkan hasil deteksi
  Future<void> _uploadImage() async {
  if (_image == null) {
    _showDialog('Peringatan', 'Silakan pilih gambar terlebih dahulu.');
    return;
  }

  setState(() {
    _isLoading = true;
  });

  try {
    final url = Uri.parse('https://ea70-114-10-16-252.ngrok-free.app/kolam'); // Pastikan URL sesuai
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('image', _image!.path)); // Ganti 'file' menjadi 'image'

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await http.Response.fromStream(response);
      final data = jsonDecode(responseBody.body);

      // Menampilkan warna dominan dan pesan deteksi
      setState(() {
        _hasilDeteksi = 'Warna Dominan: ${data['dominant_color']}\nPesan: ${data['message']}';
      });
    } else {
      _showDialog('Error', 'Gagal mendeteksi kolam. Kode status: ${response.statusCode}');
    }
  } catch (e) {
    _showDialog('Error', 'Terjadi kesalahan: $e');
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  // Fungsi untuk menampilkan dialog error
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text('Deteksi Kolam', style: TextStyle(color: Colors.white)),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
          Positioned(
            top: 50,
            left: 30,
            right: 30,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _image == null
                      ? Image.asset('assets/jenis-kolam.png', width: 160, height: 160)
                      : Image.file(_image!, width: 160, height: 160),
                  SizedBox(height: 20),
                  Text(
                    'Pilih gambar kolam untuk mendeteksi warna dominan.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: Size(140, 50),
                        ),
                        child: Text('Pilih Gambar', style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: _uploadImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: Size(140, 50),
                        ),
                        child: Text('Deteksi Kolam', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (_isLoading)
                    CircularProgressIndicator(), // Tampilkan indikator loading
                  if (_hasilDeteksi != null)
                    Text(
                      'Hasil Deteksi: $_hasilDeteksi',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
