import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medical_app/data/data_edukasi.dart';
import 'package:medical_app/page/Edukasi/detail_edukasi.dart';
import 'package:medical_app/page/Edukasi/edukasi.dart';
import 'package:medical_app/page/GlucoCheck/gluco_check.dart';
import 'package:medical_app/page/GlucoCare/gluco_care.dart';
import 'package:medical_app/page/Screening/gluco_screening.dart';
import 'package:medical_app/page/UserProfile/profile.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/services/check_services.dart';

class DashboardScreen extends StatefulWidget {
  final UserData userData;

  const DashboardScreen({super.key, required this.userData});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> checkData = [];
  bool isLoading = true;
  Map<String, dynamic>? latestHealthData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await CheckServices.getRiwayatKesehatan(context);
      await Future.delayed(const Duration(seconds: 1));

      if (data.isNotEmpty) {
        setState(() {
          checkData = data;
          latestHealthData = data[0];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading data: $e");
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'GlucoWise',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserIntro(userData: widget.userData),
            const SizedBox(height: 12),
            const SearchInput(),
            const SizedBox(height: 12),
            const CategoryIcons(),
            const SizedBox(height: 12),
            isLoading
                ? CardGlucoInfo(
                    glucoseLevel: 0,
                    bloodPressure: '0',
                    height: 0,
                    weight: 0,
                    isLoading: true,
                  )
                : latestHealthData != null
                    ? CardGlucoInfo(
                        glucoseLevel:
                            latestHealthData!['gula_darah']?.toInt() ?? 0,
                        bloodPressure:
                            latestHealthData!['tensi_darah']?.toString() ?? '0',
                        height:
                            latestHealthData!['tinggi_badan']?.toDouble() ?? 0,
                        weight:
                            latestHealthData!['berat_badan']?.toDouble() ?? 0,
                      )
                    : const CardNoData(),
          ],
        ),
      ),
    );
  }
}

class CardNoData extends StatelessWidget {
  const CardNoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFE8F3F1),
      child: const Padding(
        padding: EdgeInsets.all(15),
        child: Center(
          child: Text(
            "Belum ada data kesehatan terbaru",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF199A8E),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryIcons extends StatelessWidget {
  const CategoryIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 25,
      runSpacing: 5,
      alignment: WrapAlignment.spaceEvenly,
      children: categories.map((category) {
        return CategoryIcon(
          icon: category['icon'] as IconData,
          text: category['text'] as String,
        );
      }).toList(),
    );
  }
}

// Tambahkan daftar kategori agar tidak error
List<Map<String, dynamic>> categories = [
  {'icon': FontAwesomeIcons.heartbeat, 'text': 'Screening'},
  {'icon': FontAwesomeIcons.kitMedical, 'text': 'GlucoCheck'},
  {'icon': FontAwesomeIcons.pills, 'text': 'GlucoCare'},
  {'icon': FontAwesomeIcons.bookBookmark, 'text': 'Edukasi'},
];

class CategoryIcon extends StatefulWidget {
  final IconData icon;
  final String text;

  const CategoryIcon({
    required this.icon,
    required this.text,
    super.key,
  });

  @override
  State<CategoryIcon> createState() => _CategoryIconState();
}

class _CategoryIconState extends State<CategoryIcon> {
  void _navigateToPage(BuildContext context) {
    Widget targetPage;

    switch (widget.text) {
      case 'GlucoCare':
        targetPage = GlucoCareScreen(
          userData: UserData(
              nik: '',
              email: '',
              namaLengkap: '',
              createdAt: '',
              updatedAt: ''),
        );
        break;
      case 'Screening':
        targetPage = const GlucoScreeningScreen();
        break;
      case 'GlucoCheck':
        targetPage = GlucoCheckScreen(
          userData: UserData(
              nik: '',
              email: '',
              namaLengkap: '',
              createdAt: '',
              updatedAt: ''),
        );
        break;
      case 'Edukasi':
        targetPage = const EdukasiScreen();
        break;
      default:
        targetPage = DashboardScreen(
          userData: UserData(
              nik: '',
              email: '',
              namaLengkap: '',
              createdAt: '',
              updatedAt: ''),
        );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color(0xFFE8F3F1),
      onTap: () => _navigateToPage(context),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3F1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                widget.icon,
                color: const Color(0xFF199A8E),
                size: 25,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.text,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(
              Icons.search,
              color: Color(0xFF199A8E),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardGlucoInfo extends StatelessWidget {
  final int glucoseLevel;
  final String bloodPressure;
  final double height;
  final double weight;
  final String? lastCheckDate;
  final bool isLoading;

  const CardGlucoInfo({
    super.key,
    required this.glucoseLevel,
    required this.bloodPressure,
    required this.height,
    required this.weight,
    this.lastCheckDate,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final glucoseStatus = _getGlucoseStatus(glucoseLevel);
    final bmi = _calculateBMI(height, weight);
    final bmiStatus = _getBMIStatus(bmi);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFE8F3F1).withOpacity(0.9),
              const Color(0xFFD4E8E4),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isLoading
              ? Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Color(0xFF199A8E),
                    size: 50,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          _buildHeaderIcon(),
                          const SizedBox(width: 10),
                          const Text(
                            'Gluco Info',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF199A8E),
                            ),
                          ),
                        ]),
                        if (lastCheckDate != null)
                          _buildLastCheckedDate(lastCheckDate!),
                        const Spacer(),
                        const Icon(
                          Icons.medication_rounded,
                          color: Color(0xFF199A8E),
                          size: 32,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildGlucoseSection(glucoseStatus, glucoseLevel),
                    const SizedBox(height: 16),
                    _buildVitalStatsSection(
                        bloodPressure, height, weight, bmi, bmiStatus),
                    const SizedBox(height: 8),
                    _buildStatusIndicator(glucoseStatus, bmiStatus),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF199A8E),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(
        FontAwesomeIcons.droplet,
        color: Colors.white,
        size: 22,
      ),
    );
  }

  Widget _buildLastCheckedDate(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "Updated: $date",
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF199A8E),
        ),
      ),
    );
  }

  Widget _buildGlucoseSection(GlucoseStatus status, int glucoseLevel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tingkat Glukosa Darah',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                glucoseLevel.toString(),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: status.color,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'mg/dL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: status.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: status.color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: status.level,
            backgroundColor: Colors.grey[200],
            color: status.color,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalStatsSection(
    String bloodPressure,
    double height,
    double weight,
    double bmi,
    BMIStatus bmiStatus,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildVitalStatItem(
            icon: FontAwesomeIcons.heartPulse,
            title: 'Tekanan Darah',
            value: '$bloodPressure mmHg',
            color: const Color(0xFF199A8E),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildVitalStatItem(
            icon: FontAwesomeIcons.rulerVertical,
            title: 'Tinggi Badan',
            value: '${height.toStringAsFixed(1)} cm',
            color: const Color(0xFF199A8E),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildVitalStatItem(
            icon: FontAwesomeIcons.weightScale,
            title: 'Berat Badan',
            value: '${weight.toStringAsFixed(1)} kg',
            color: const Color(0xFF199A8E),
          ),
        ),
      ],
    );
  }

  Widget _buildVitalStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 18,
            color: color,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(
      GlucoseStatus glucoseStatus, BMIStatus bmiStatus) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatusBar(
                  'Glukosa', glucoseStatus.color, glucoseStatus.level),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatusBar('IMT', bmiStatus.color, bmiStatus.level),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Glukosa: ${glucoseStatus.label}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: glucoseStatus.color,
              ),
            ),
            Text(
              'IMT: ${bmiStatus.label}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: bmiStatus.color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBar(String label, Color color, double level) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            children: [
              Container(
                width: level * 100,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper methods for health status
  GlucoseStatus _getGlucoseStatus(int level) {
    if (level < 70) return GlucoseStatus('Rendah', Colors.blue, 0.3);
    if (level < 100) return GlucoseStatus('Normal', Colors.green, 0.5);
    if (level < 126) return GlucoseStatus('Tinggi', Colors.orange, 0.7);
    return GlucoseStatus('Terlalu Tinggi', Colors.red, 1.0);
  }

  double _calculateBMI(double height, double weight) {
    if (height <= 0) return 0;
    return weight / ((height / 100) * (height / 100));
  }

  BMIStatus _getBMIStatus(double bmi) {
    if (bmi < 18.5) return BMIStatus('Berat badan kurang', Colors.blue, 0.3);
    if (bmi < 25) return BMIStatus('Normal', Colors.green, 0.5);
    if (bmi < 30) return BMIStatus('Kelebihan berat badan', Colors.orange, 0.7);
    return BMIStatus('Obesitas', Colors.red, 1.0);
  }
}

class GlucoseStatus {
  final String label;
  final Color color;
  final double level;

  GlucoseStatus(this.label, this.color, this.level);
}

class BMIStatus {
  final String label;
  final Color color;
  final double level;

  BMIStatus(this.label, this.color, this.level);
}

class UserIntro extends StatelessWidget {
  final UserData userData;

  const UserIntro({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hi,',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text(
              userData.namaLengkap,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
            ),
            Text(
              userData.nik,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Get.to(() => UserScreen(userData: userData));
          },
          child: const CircleAvatar(
            backgroundColor: Color(0xFFE8F3F1),
            radius: 25,
            child: Icon(
              FontAwesomeIcons.userAlt,
              color: Color(0xFF199A8E),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }
}
