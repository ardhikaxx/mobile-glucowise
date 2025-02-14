import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/components/navbottom.dart';

class GlucoScreeningScreen extends StatelessWidget {
  const GlucoScreeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Screening',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(9.0),
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF199A8E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NavBottom()),
                );
              },
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Screening Diabetes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'DarumadropOne',
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF199A8E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Screening ini membantumu mengidentifikasi risiko diabetes lebih awal, memungkinkan pencegahan yang lebih optimal.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildRiskCard(
              FontAwesomeIcons.circleCheck,
              'Risiko Rendah (1-20)',
              'Risiko rendah berarti kamu memiliki kemungkinan kecil untuk terkena diabetes. Tetap jaga pola makan dan olahraga rutin.',
              Colors.green,
            ),
            _buildRiskCard(
              FontAwesomeIcons.exclamationTriangle,
              'Risiko Sedang (21-30)',
              'Risiko sedang menunjukkan adanya kemungkinan terkena diabetes. Disarankan untuk menjaga pola hidup sehat dan berkonsultasi dengan dokter.',
              Colors.orange,
            ),
            _buildRiskCard(
              FontAwesomeIcons.triangleExclamation,
              'Risiko Tinggi (31-40)',
              'Risiko tinggi menunjukkan kemungkinan besar terkena diabetes. Segera lakukan pemeriksaan medis dan perubahan gaya hidup.',
              Colors.red,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF199A8E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Tambahkan navigasi ke halaman screening test
                },
                child: const Text(
                  'Mulai Screening',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskCard(
      IconData icon, String title, String description, Color color) {
    return Card(
      color: const Color(0xFFE8F3F1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.black.withOpacity(0.5),
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
