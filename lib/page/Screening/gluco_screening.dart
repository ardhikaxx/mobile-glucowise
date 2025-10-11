import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medical_app/page/Screening/riwayat_screening.dart';
import 'package:medical_app/page/Screening/test_screening.dart';
import 'package:medical_app/services/screening_services.dart';
import 'package:medical_app/model/user.dart';

class GlucoScreeningScreen extends StatelessWidget {
  final UserData userData;

  const GlucoScreeningScreen({super.key, required this.userData});

  Future<void> _checkQuestionsAvailability(BuildContext context) async {
    try {
      final questions = await ScreeningServices.getQuestions();
      if (questions == null ||
          questions['data'] == null ||
          (questions['data'] as List).isEmpty) {
        _showQuestionsUnavailableDialog(context);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestScreeningScreen(userData: userData),
          ),
        );
      }
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _showQuestionsUnavailableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Akses Screening Belum Tersedia",
          style: TextStyle(
            color: Color(0xFF199A8E),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Mohon maaf, saat ini layanan screening belum dapat digunakan karena:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            _buildAlertItem("Data pertanyaan screening belum tersedia"),
            _buildAlertItem("Layanan sedang dalam pemeliharaan"),
            _buildAlertItem("Atau masalah teknis lainnya"),
            const SizedBox(height: 10),
            const Text(
              "Silakan coba lagi nanti.",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Tutup",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF199A8E),
            ),
            onPressed: () => Get.back(),
            child: const Text(
              "Mengerti",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Terjadi Kesalahan"),
        content: Text("Gagal memuat data: $error"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4, right: 8),
            child: Icon(
              Icons.circle,
              size: 8,
              color: Color(0xFF199A8E),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
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
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        // leading: Padding(
        //   padding: const EdgeInsets.all(9.0),
        //   child: Container(
        //     height: 40,
        //     width: 40,
        //     decoration: BoxDecoration(
        //       color: const Color(0xFF199A8E),
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //     child: IconButton(
        //       onPressed: () => Get.offAll(() => NavBottom(userData: userData)),
        //       icon: const Icon(
        //         FontAwesomeIcons.chevronLeft,
        //         color: Colors.white,
        //         size: 20,
        //       ),
        //     ),
        //   ),
        // ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const _HeaderSection(),
              const SizedBox(height: 20),
              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _RiskCard(
                      icon: Iconsax.tick_circle,
                      title: 'Indikasi Rendah',
                      scoreRange: '0-7',
                      description:
                          'Indikasi diabetes sangat rendah. Untuk tetap terhindar, pastikan untuk menjaga pola makan sehat dan rutin berolahraga.',
                      color: Color(0xFF4CAF50),
                    ),
                    SizedBox(width: 15),
                    _RiskCard(
                      icon: Iconsax.warning_2,
                      title: 'Indikasi Sedang',
                      scoreRange: '8-14',
                      description:
                          'Indikasi sedang. Disarankan untuk mulai memperbaiki pola makan, meningkatkan aktivitas fisik, dan menjaga berat badan ideal.',
                      color: Color(0xFFFF9800),
                    ),
                    SizedBox(width: 15),
                    _RiskCard(
                      icon: Iconsax.danger,
                      title: 'Indikasi Tinggi',
                      scoreRange: '15-24',
                      description:
                          'Indikasi tinggi. Sebaiknya segera konsultasi dengan dokter dan lakukan pemeriksaan gula darah secara rutin untuk memantau kondisi kesehatan.',
                      color: Color(0xFFF44336),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              _ActionButtons(
                onStartScreening: () => _checkQuestionsAvailability(context),
                userData: userData,
              ),
              const SizedBox(height: 25),
              const _AdditionalInfo(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RiskCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String scoreRange;
  final String description;
  final Color color;

  const _RiskCard({
    required this.icon,
    required this.title,
    required this.scoreRange,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: color,
                  width: 5,
                ),
              ),
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          Text(
                            'Skor: $scoreRange',
                            style: TextStyle(
                              fontSize: 14,
                              color: color.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Indikasi Level Diabetes",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF199A8E),
            fontFamily: 'DarumadropOne',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Deteksi dini indikasi diabetes dengan screening ini. Ambil langkah preventif untuk kesehatan yang lebih baik.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onStartScreening;
  final UserData userData;

  const _ActionButtons({
    required this.onStartScreening,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF199A8E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              shadowColor: const Color(0xFF199A8E).withOpacity(0.4),
            ),
            onPressed: onStartScreening,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.clipboardUser,
                    size: 20, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Mulai Screening',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF199A8E)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RiwayatScreening(userData: userData),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.history,
                    size: 18, color: Color(0xFF199A8E)),
                SizedBox(width: 10),
                Text(
                  'Lihat Riwayat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF199A8E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AdditionalInfo extends StatelessWidget {
  const _AdditionalInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF199A8E).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(FontAwesomeIcons.circleInfo,
              color: Color(0xFF199A8E), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Screening ini membantu mengidentifikasi indikasi diabetes tipe 2 berdasarkan faktor gaya hidup dan riwayat kesehatan.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
