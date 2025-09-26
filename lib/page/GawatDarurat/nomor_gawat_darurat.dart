import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class NomorGawatDarurat extends StatefulWidget {
  const NomorGawatDarurat({super.key});

  @override
  State<NomorGawatDarurat> createState() => _NomorGawatDaruratState();
}

class _NomorGawatDaruratState extends State<NomorGawatDarurat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F6),
      appBar: AppBar(
        title: const Text(
          'Nomor Darurat',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
              onPressed: () => Get.back(),
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hubungi nomor darurat berikut untuk mendapatkan bantuan medis segera dan secepat mungkin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF5D5D5D),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    EmergencyContactCard(
                      icon: FontAwesomeIcons.hospital,
                      title: 'Halo Kemenkes',
                      subtitle: 'Layanan dan informasi Kemenkes',
                      phoneNumber: '1500567',
                      color: const Color(0xFF138075),
                    ),
                    const SizedBox(height: 16),
                    EmergencyContactCard(
                      icon: FontAwesomeIcons.exclamationTriangle,
                      title: 'Kondisi Gawat Darurat',
                      subtitle: 'Penanganan medis cepat tanggap',
                      phoneNumber: '119',
                      color: const Color(0xFF138075),
                    ),
                    const SizedBox(height: 16),
                    EmergencyContactCard(
                      icon: FontAwesomeIcons.ambulance,
                      title: 'Layanan Ambulans',
                      subtitle: 'Mengangkut pasien gawat darurat',
                      phoneNumber: '112',
                      color: const Color(0xFF138075),
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

class EmergencyContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String phoneNumber;
  final Color color;

  const EmergencyContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.phoneNumber,
    required this.color,
  });

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri telLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    
    try {
      await launchUrl(telLaunchUri);
    } catch (e) {
      _showErrorDialog(
        'Tidak dapat melakukan panggilan',
        'Pastikan perangkat Anda mendukung panggilan telepon dan memiliki aplikasi telepon yang sesuai.'
      );
    }
  }

  void _showErrorDialog(String title, String message) {
    print('Error: $title - $message');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101623),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF717784),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.phone,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () {
                  _makePhoneCall(phoneNumber);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}