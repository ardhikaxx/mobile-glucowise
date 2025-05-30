import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medical_app/page/Edukasi/edukasi.dart';
import 'package:medical_app/page/GlucoCheck/gluco_check.dart';
import 'package:medical_app/page/GlucoCare/gluco_care.dart';
import 'package:medical_app/page/Screening/gluco_screening.dart';
import 'package:medical_app/page/UserProfile/profile.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/page/chat_bot/chat_ai.dart';
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
  Map<String, dynamic>? statusData;
  bool _mounted = false;
  late UserData _currentUserData;

  @override
  void initState() {
    super.initState();
    _mounted = true;
    _currentUserData = widget.userData;
    _loadData();
  }

  @override
  void didUpdateWidget(DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userData != oldWidget.userData) {
      setState(() {
        _currentUserData = widget.userData;
      });
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }

  void _loadData() async {
    if (!_mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final data = await CheckServices.getRiwayatKesehatan(context);

      if (!_mounted) return;

      await Future.delayed(const Duration(seconds: 1));

      if (data.isNotEmpty) {
        final latestData = data[0];
        final status =
            await CheckServices.getStatusRisiko(context, latestData["id_data"]);

        if (_mounted) {
          setState(() {
            checkData = data;
            latestHealthData = latestData;
            statusData = status;
            isLoading = false;
          });
        }
      } else if (_mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading data: $e");
      await Future.delayed(const Duration(seconds: 1));

      if (_mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UserIntro(userData: _currentUserData),
              const SizedBox(height: 15),
              _buildGlucoziaAICard(context),
              const SizedBox(height: 20),
              const CategoryIcons(),
              const SizedBox(height: 5),
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
                              latestHealthData!['tensi_darah']?.toString() ??
                                  '0',
                          height:
                              latestHealthData!['tinggi_badan']?.toDouble() ??
                                  0,
                          weight:
                              latestHealthData!['berat_badan']?.toDouble() ?? 0,
                          status:
                              statusData?['kategori_risiko'] ?? 'Dalam proses',
                        )
                      : const CardNoData(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlucoziaAICard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ChatBotPage(),
            transitionsBuilder: (_, animation, __, child) {
              return ScaleTransition(
                scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
                ),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          ),
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF138075),
                Color(0xFF199A8E),
                Color(0xFF23B8A9),
              ],
              stops: [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFE0F7FA)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF138075),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Color(0xFFE0F7FA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        'Glucozia AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'DarumadropOne',
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tanya seputar tentang diabetes',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardNoData extends StatelessWidget {
  const CardNoData({
    super.key,
    this.message = "Belum ada data kesehatan terbaru anda",
    this.subMessage = "Silakan periksa kembali nanti",
  });

  final String message;
  final String subMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFF9FAFB),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3F1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3F1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF138075),
                        Color(0xFF199A8E),
                        Color(0xFF23B8A9),
                      ],
                      stops: [0.0, 0.5, 1.0],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1DE9B6).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    FontAwesomeIcons.circleExclamation,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF263238),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryIcons extends StatelessWidget {
  const CategoryIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: MediaQuery.of(context).size.width < 400 ? 5 : 20,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      children: categories.map((category) {
        return CategoryIcon(
          icon: category['icon'] as IconData,
          text: category['text'] as String,
        );
      }).toList(),
    );
  }
}

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
    final dashboardState =
        context.findAncestorStateOfType<_DashboardScreenState>();
    final userData = dashboardState?._currentUserData ??
        UserData(
            nik: '', email: '', namaLengkap: '', createdAt: '', updatedAt: '');

    Widget targetPage;

    switch (widget.text) {
      case 'GlucoCare':
        targetPage = GlucoCareScreen(userData: userData);
        break;
      case 'Screening':
        targetPage = GlucoScreeningScreen(userData: userData);
        break;
      case 'GlucoCheck':
        targetPage = GlucoCheckScreen(userData: userData);
        break;
      case 'Edukasi':
        targetPage = EdukasiScreen(userData: userData);
        break;
      default:
        targetPage = DashboardScreen(userData: userData);
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

class CardGlucoInfo extends StatelessWidget {
  final int glucoseLevel;
  final String bloodPressure;
  final double height;
  final double weight;
  final String? lastCheckDate;
  final bool isLoading;
  final String status;

  const CardGlucoInfo({
    super.key,
    required this.glucoseLevel,
    required this.bloodPressure,
    required this.height,
    required this.weight,
    this.lastCheckDate,
    this.isLoading = false,
    this.status = 'Dalam proses',
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = status == "Tinggi"
        ? Colors.red
        : status == "Sedang"
            ? Colors.orange
            : status == "Rendah"
                ? Colors.green
                : Colors.grey;

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
                  child: LoadingAnimationWidget.progressiveDots(
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
                        Icon(
                          status == "Tinggi"
                              ? FontAwesomeIcons.solidFaceFrown
                              : status == "Sedang"
                                  ? FontAwesomeIcons.faceMeh
                                  : status == "Rendah"
                                      ? FontAwesomeIcons.solidFaceSmile
                                      : FontAwesomeIcons.clock,
                          color: statusColor,
                          size: 32,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildGlucoseSection(statusColor, glucoseLevel),
                    const SizedBox(height: 16),
                    _buildVitalStatsSection(
                        bloodPressure, height, weight, bmi, bmiStatus),
                    const SizedBox(height: 8),
                    _buildStatusIndicator(statusColor, bmiStatus),
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

  Widget _buildGlucoseSection(Color statusColor, int glucoseLevel) {
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
                  color: statusColor,
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
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: _getGlucoseLevelValue(glucoseLevel),
            backgroundColor: Colors.grey[200],
            color: statusColor,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    );
  }

  double _getGlucoseLevelValue(int level) {
    if (level < 70) return 0.3;
    if (level < 100) return 0.5;
    if (level < 126) return 0.7;
    return 1.0;
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

  Widget _buildStatusIndicator(Color statusColor, BMIStatus bmiStatus) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatusBar('Status Risiko', statusColor,
                  _getGlucoseLevelValue(glucoseLevel)),
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
              'Status: $status',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: statusColor,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Halo, ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    userData.namaLengkap.split(' ')[0],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF199A8E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.verified_user,
                    size: 18,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(width: 4),
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
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.to(
                () => UserScreen(userData: userData),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 300),
              );
            },
            child: Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF138075),
                    Color(0xFF199A8E),
                    Color(0xFF23B8A9),
                  ],
                  stops: [0.0, 0.5, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                FontAwesomeIcons.userEdit,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
