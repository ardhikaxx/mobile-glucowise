import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/components/navbottom.dart';
import 'package:medical_app/page/Screening/riwayat_screening.dart';
import 'package:medical_app/page/Screening/test_screening.dart';
import 'package:medical_app/services/screening_services.dart';
import 'package:quickalert/quickalert.dart';
import 'package:medical_app/model/user.dart';

class GlucoScreeningScreen extends StatelessWidget {
  final UserData userData;
  const GlucoScreeningScreen({super.key, required this.userData});

  Future<void> _checkQuestionsAvailability(BuildContext context) async {
    final questions = await ScreeningServices.getQuestions();

    if (questions == null ||
        questions['data'] == null ||
        (questions['data'] as List).isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: 'Akses Dibatasi',
        text:
            'Screening belum bisa digunakan saat ini. Silakan coba lagi nanti.',
        confirmBtnColor: const Color(0xFF199A8E),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TestScreeningScreen(userData: userData)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Screening Diabetes',
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
                Get.offAll(() => NavBottom(userData: userData));
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              const Text(
                "Risiko Diabetes",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF199A8E),
                  fontFamily: 'DarumadropOne',
                ),
              ),
            ]),
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
                onPressed: () => _checkQuestionsAvailability(context),
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
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xFF199A8E), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RiwayatScreening(userData: userData),
                  ),
                ),
                child: const Text(
                  'Lihat Riwayat Screening',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF199A8E),
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
