import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/page/Screening/detail_hasil_screening.dart';
import 'package:medical_app/services/screening_services.dart';
import 'package:medical_app/utils/session_manager.dart';

class HasilScreeningScreen extends StatefulWidget {
  final int totalScore;

  const HasilScreeningScreen({super.key, required this.totalScore});

  @override
  State<HasilScreeningScreen> createState() => _HasilScreeningScreenState();
}

class _HasilScreeningScreenState extends State<HasilScreeningScreen> {
  List<dynamic> screeningHistory = [];
  bool isLoading = true;
  DateTime currentDate = DateTime.now(); // Tambahkan variabel untuk tanggal saat ini

  @override
  void initState() {
    super.initState();
    _loadScreeningHistory();
  }

  Future<void> _loadScreeningHistory() async {
    final nik = await SessionManager.getNik();
    if (nik == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final history = await ScreeningServices.getScreeningHistory(nik, context);
    if (history != null) {
      setState(() {
        screeningHistory = history;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Color _getRiskColor(int score) {
    if (score <= 7) return const Color(0xFF4CAF50); // Green
    if (score <= 14) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFF44336); // Red
  }

  String _getRiskLevel(int score) {
    if (score <= 7) return 'Indikasi Rendah';
    if (score <= 14) return 'Indikasi Sedang';
    return 'Indikasi Tinggi';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now());
    }
  }

  // Format tanggal untuk header
  String get formattedCurrentDate {
    return '${currentDate.day}/${currentDate.month}/${currentDate.year}';
  }

  Widget _buildRiskIndicator(int score) {
    final color = _getRiskColor(score);
    final level = _getRiskLevel(score);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final riskColor = _getRiskColor(widget.totalScore);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Hasil Screening',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 28,
            fontWeight: FontWeight.bold,
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
              onPressed: () {
                Get.back();
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
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF199A8E)),
                ),
              )
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header with gradient
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          decoration: const BoxDecoration(
                            color: Color(0xFF199A8E),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(FontAwesomeIcons.kitMedical, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    'SCREENING',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.9),
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                formattedCurrentDate, // Gunakan tanggal saat ini
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Score Circle
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 140,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          riskColor.withOpacity(0.15),
                                          riskColor.withOpacity(0.05),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: riskColor,
                                        width: 4,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${widget.totalScore}',
                                            style: TextStyle(
                                              fontSize: 42,
                                              fontWeight: FontWeight.bold,
                                              color: riskColor,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Skor',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: riskColor.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Risk Level
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 24),
                                decoration: BoxDecoration(
                                  color: riskColor.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  _getRiskLevel(widget.totalScore),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Description
                              Text(
                                _getIndikasiDescription(widget.totalScore),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF6C757D),
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Recommendations
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.medical_services,
                                          color: riskColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Rekomendasi',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: riskColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _getIndikasiRecommendation(
                                          widget.totalScore),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF6C757D),
                                        height: 1.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Text(
                          'Riwayat Screening',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF199A8E),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${screeningHistory.length} Total',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6C757D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: screeningHistory.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history_outlined,
                                  size: 60,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Belum ada riwayat sebelumnya',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6C757D),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: screeningHistory.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = screeningHistory[index];
                              final score = item['skor_risiko'] ?? 0;
                              final date = item['tanggal_screening'] != null 
                                  ? _formatDate(item['tanggal_screening'])
                                  : 'Tanggal tidak tersedia';
                              final riskColor = _getRiskColor(score);

                              return InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailHasilScreeningScreen(
                                        screeningId: item['id_screening'],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: riskColor.withOpacity(0.1),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: riskColor.withOpacity(0.3),
                                              width: 2,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              score.toString(),
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: riskColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Screening #${item['id_screening'] ?? 'N/A'}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                date,
                                                style: const TextStyle(
                                                  color: Color(0xFF6C757D),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            _buildRiskIndicator(score),
                                            const SizedBox(height: 8),
                                            const Icon(
                                              Icons.chevron_right,
                                              color: Color(0xFFADB5BD),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  String _getIndikasiDescription(int score) {
    if (score <= 7) {
      return 'Hasil screening menunjukkan indikasi diabetes yang rendah. Pertahankan gaya hidup sehat dengan pola makan seimbang dan aktivitas fisik rutin.';
    } else if (score <= 14) {
      return 'Hasil screening menunjukkan indikasi diabetes sedang. Disarankan untuk berkonsultasi dengan dokter dan melakukan pemeriksaan lebih lanjut.';
    } else {
      return 'Hasil screening menunjukkan indikasi diabetes tinggi. Segera konsultasikan dengan dokter untuk evaluasi lebih lanjut dan penanganan tepat.';
    }
  }

  String _getIndikasiRecommendation(int score) {
    if (score <= 7) {
      return '• Lanjutkan pola makan sehat\n• Olahraga rutin 30 menit/hari\n• Periksa gula darah setahun sekali';
    } else if (score <= 14) {
      return '• Konsultasi dengan dokter\n• Periksa gula darah 6 bulan sekali\n• Mulai program diet sehat\n• Tingkatkan aktivitas fisik';
    } else {
      return '• Segera konsultasi dokter\n• Periksa gula darah 3 bulan sekali\n• Program diet khusus\n• Olahraga teratur\n• Pantau gejala diabetes';
    }
  }
}
