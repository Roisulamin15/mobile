// informasi_penyakit_screen.dart
import 'package:flutter/material.dart';

class InformasiKolamScreen extends StatelessWidget {
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
                'Penyakit akibat kualitas air',
                'Penyakit akibat kualitas air buruk disebabkan oleh tingginya amonia atau nitrit dan rendahnya oksigen akibat penumpukan limbah. Gejalanya meliputi ikan gelisah, sering ke permukaan, warna pucat, dan nafsu makan menurun.',
              ),
              buildInfoCard(
                'Penyakit Akibat Parasit',
                'Penyakit parasit pada ikan disebabkan oleh protozoa, cacing, atau kutu yang menempel pada tubuh ikan, terutama di kolam padat atau dengan kualitas air buruk. Gejalanya termasuk ikan sering menggosok tubuh ke permukaan, muncul bintik putih, atau lesu.',
              ),
              buildInfoCard(
                'Penyakit Akibat Bakteri',
                'Penyakit bakteri pada ikan disebabkan oleh bakteri seperti *Aeromonas* atau *Flavobacterium* yang berkembang di kolam berkualitas air buruk atau pada ikan yang stres. Gejalanya meliputi luka merah, pembengkakan tubuh, sirip robek, dan bercak putih pada mulut serta insang.',
              ),
              buildInfoCard(
                'Penyakit Akibat Jamur',
                'Penyakit akibat jamur pada ikan terjadi saat jamur seperti *Saprolegnia* tumbuh pada luka atau jaringan rusak, terutama di kolam berkualitas air rendah. Gejalanya berupa bercak putih seperti kapas pada area terinfeksi, biasanya di kulit atau sirip.',
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
