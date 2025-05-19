import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  @override
  void initState() {
    super.initState();
    _loadScreeningHistory();
  }

  Future<void> _loadScreeningHistory() async {
    final nik = await SessionManager.getNik();
    if (nik == null) return;

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
    if (score <= 7) return 'Risiko Rendah';
    if (score <= 14) return 'Risiko Sedang';
    return 'Risiko Tinggi';
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
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
    final riskGradient = LinearGradient(
      colors: [
        riskColor.withOpacity(0.1),
        riskColor.withOpacity(0.05),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

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
                Navigator.pop(context);
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
      body: SafeArea(child: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF199A8E)),
              ),
            )
          : Column(
              children: [
                // Current result card
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: riskGradient,
                          ),
                        ),
                        // Card content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                'HASIL SCREENING TERAKHIR',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'DarumadropOne',
                                  color: riskColor,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: riskColor.withOpacity(0.3),
                                    width: 2,
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      riskColor.withOpacity(0.2),
                                      riskColor.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    '${widget.totalScore}',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: riskColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _getRiskLevel(widget.totalScore),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: riskColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  _getRiskDescription(widget.totalScore),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF6C757D),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: riskColor,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(18),
                                bottomLeft: Radius.circular(18),
                              ),
                            ),
                            child: Text(
                              'SEKARANG',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // History section
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
                            final score = item['skor_risiko'];
                            final date = _formatDate(item['tanggal_screening']);
                            final riskColor = _getRiskColor(score);
                            _getRiskLevel(score);

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
                                              'Screening #${item['id_screening']}',
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

  String _getRiskDescription(int score) {
    if (score <= 7) {
      return 'Risiko diabetes sangat rendah. Untuk tetap terhindar, pastikan untuk menjaga pola makan sehat dan rutin berolahraga.';
    } else if (score <= 14) {
      return 'Risiko sedang. Disarankan untuk mulai memperbaiki pola makan, meningkatkan aktivitas fisik, dan menjaga berat badan ideal.';
    } else {
      return 'Risiko tinggi. Sebaiknya segera konsultasi dengan dokter dan lakukan pemeriksaan gula darah secara rutin untuk memantau kondisi kesehatan.';
    }
  }
}
