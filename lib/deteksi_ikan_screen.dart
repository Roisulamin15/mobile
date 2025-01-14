import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class DeteksiIkanScreen extends StatefulWidget {
  @override
  _DeteksiIkanScreenState createState() => _DeteksiIkanScreenState();
}

class _DeteksiIkanScreenState extends State<DeteksiIkanScreen> {
  File? _image;
  String? _result;

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Fungsi untuk mengunggah gambar dan mendapatkan hasil prediksi
  Future<void> _detectDisease() async {
    if (_image == null) return;

    final uri = Uri.parse('\https://ea70-114-10-16-252.ngrok-free.app/p'); // Pastikan URL ngrok Anda benar
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', _image!.path)); // Pastikan nama field 'file'

    setState(() {
      _result = 'Sedang menganalisis...';
    });

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();

        // Cek apakah respons yang diterima berupa JSON
        if (responseData.startsWith("{")) {
          final jsonResponse = json.decode(responseData);
          setState(() {
            _result = jsonResponse['penyakit'] ?? 'Tidak ditemukan informasi penyakit';
          });
        } else {
          setState(() {
            _result = 'Respons tidak dalam format JSON. Mungkin ada kesalahan di server.';
          });
        }
      } else {
        setState(() {
          _result = 'Gagal menganalisis gambar: Status ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Terjadi kesalahan: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Deteksi Penyakit Ikan',
            style: TextStyle(color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/penyakit-ikan.png',
                    width: 160,
                    height: 160,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Unggah gambar ikan untuk mendeteksi penyakit.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  if (_image != null)
                    Image.file(
                      _image!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  if (_result != null) ...[
                    SizedBox(height: 20),
                    Text(
                      'Hasil Deteksi:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      _result!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(200, 50),
                    ),
                    child: Text(
                      'Upload Image',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _detectDisease,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(200, 50),
                    ),
                    child: Text(
                      'Deteksi Penyakit',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
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
