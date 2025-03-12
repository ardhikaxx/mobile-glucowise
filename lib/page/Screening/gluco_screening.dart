import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/components/navbottom.dart';
import 'package:medical_app/page/Screening/test_screening.dart';

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
            fontSize: 35,
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const NavBottom()),
                // );
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  'Screening ini membantumu mengenali risiko diabetes lebih awal, sehingga bisa segera mengambil langkah pencegahan yang tepat.',
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
              'Risiko Rendah (0-7)',
              'Risiko diabetes sangat rendah. Untuk tetap terhindar, pastikan untuk menjaga pola makan sehat dan rutin berolahraga.',
              Colors.green,
            ),
            _buildRiskCard(
              // ignore: deprecated_member_use
              FontAwesomeIcons.exclamationTriangle,
              'Risiko Sedang (8-14)',
              'Risiko sedang. Disarankan untuk mulai memperbaiki pola makan, meningkatkan aktivitas fisik, dan menjaga berat badan ideal.',
              Colors.orange,
            ),
            _buildRiskCard(
              FontAwesomeIcons.triangleExclamation,
              'Risiko Tinggi (15-24)',
              'Risiko tinggi. Sebaiknya segera konsultasi dengan dokter dan lakukan pemeriksaan gula darah secara rutin untuk memantau kondisi kesehatan.',
              Colors.red,
            ),
            const SizedBox(height: 5),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TestScreeningScreen(),
                    ),
                  );
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 15),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ikon dalam lingkaran
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 15),

              // Text di dalam Card
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
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
