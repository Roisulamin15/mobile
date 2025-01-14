// informasi_penyakit_screen.dart
import 'package:flutter/material.dart';

class InformasiPenyakitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text(
          'penyakit ikan',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Warna ikon back menjadi putih
        ),
      ),
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              buildInfoCard(
                'Penyakit akibat parasit',
                'Penyakit yang disebabkan oleh bakteri pada ikan, seperti infeksi Vibrio, Aeromonas, dan Edwardsiella',
              ),
              buildInfoCard(
                'Penyakit Akibat Bakteri',
                'Penyakit yang disebabkan oleh bakteri pada ikan, seperti infeksi Vibrio, Aeromonas, dan Edwardsiella, dapat menyebabkan luka pada kulit, peradangan organ internal, dan kematian massal',
              ),
              buildInfoCard(
                'Penyakit Akibat Virus',
                'Infeksi virus pada ikan, seperti nodavirus, birnavirus, dan viral hemorrhagic septicemia (VHS), dapat merusak sistem imun, menyebabkan pendarahan',
              ),
              buildInfoCard(
                'Penyakit Akibat Lingkungan',
                'Faktor lingkungan seperti polusi, perubahan suhu, kekurangan oksigen, dan kualitas air yang buruk dapat menyebabkan stres, menurunkan daya tahan tubuh ikan, serta memicu penyakit dan kematian',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
