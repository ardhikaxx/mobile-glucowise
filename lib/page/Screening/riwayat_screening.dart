import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/page/Screening/detail_hasil_screening.dart';
import 'package:medical_app/page/Screening/gluco_screening.dart';
import 'package:medical_app/services/screening_services.dart';
import 'package:medical_app/utils/session_manager.dart';
import 'package:intl/intl.dart';

class RiwayatScreening extends StatefulWidget {
  final UserData userData;
  const RiwayatScreening({super.key, required this.userData});

  @override
  State<RiwayatScreening> createState() => _RiwayatScreeningState();
}

class _RiwayatScreeningState extends State<RiwayatScreening> {
  List<dynamic> screeningHistory = [];
  bool isLoading = true;
  bool _isDateFormatInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeDateFormatting();
  }

  Future<void> _initializeDateFormatting() async {
    try {
      await initializeDateFormatting('id', null);
      setState(() {
        _isDateFormatInitialized = true;
      });
      _loadScreeningHistory();
    } catch (e) {
      print('Error initializing date formatting: $e');
      // Fallback: load data anyway, will use default locale
      _loadScreeningHistory();
    }
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
    if (score <= 7) return const Color(0xFF4CAF50);
    if (score <= 14) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  String _getRiskLevel(int score) {
    if (score <= 7) return 'Rendah';
    if (score <= 14) return 'Sedang';
    return 'Tinggi';
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      if (_isDateFormatInitialized) {
        return DateFormat('dd MMMM yyyy, HH:mm', 'id').format(date);
      } else {
        // Fallback format jika inisialisasi gagal
        return DateFormat('dd/MM/yyyy, HH:mm').format(date);
      }
    } catch (e) {
      return 'Tanggal tidak valid';
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
          'Riwayat Screening',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF1A998E),
            fontSize: 30,
            fontWeight: FontWeight.w600,
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
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(const Color(0xFF1A998E)),
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Text(
                        'Semua Riwayat Screening',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    Expanded(
                      child: screeningHistory.isEmpty
                          ? _buildEmptyState()
                          : RefreshIndicator(
                              color: const Color(0xFF1A998E),
                              onRefresh: _loadScreeningHistory,
                              child: GridView.builder(
                                padding: const EdgeInsets.only(bottom: 20),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 3.2,
                                ),
                                itemCount: screeningHistory.length,
                                itemBuilder: (context, index) {
                                  final item = screeningHistory[index];
                                  final score = item['skor_risiko'];
                                  final date =
                                      _formatDate(item['tanggal_screening']);
                                  final riskColor = _getRiskColor(score);
                                  final riskLevel = _getRiskLevel(score);

                                  return Card(
                                    elevation: 2,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    shadowColor: Colors.black.withOpacity(0.8),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DetailHasilScreeningScreen(
                                            screeningId: item['id_screening'],
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    riskColor.withOpacity(0.1),
                                                border: Border.all(
                                                  color: riskColor
                                                      .withOpacity(0.3),
                                                  width: 2,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '$score',
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: riskColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            // Details
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'ID: #${item['id_screening']}',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 12,
                                                                vertical: 4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: riskColor
                                                              .withOpacity(0.1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Text(
                                                          riskLevel,
                                                          style: TextStyle(
                                                            color: riskColor,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    date,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  LinearProgressIndicator(
                                                    value: score / 15,
                                                    backgroundColor:
                                                        Colors.grey[200],
                                                    color: riskColor,
                                                    minHeight: 6,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            // Arrow
                                            Icon(
                                              FontAwesomeIcons.chevronRight,
                                              color: Colors.grey[400],
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final userData = widget.userData;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9F8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 64,
                color: Color(0xFF1A998E),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Tidak Ada Riwayat',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A998E),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Mulai screening pertama Anda untuk melihat riwayat hasil pemeriksaan di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => GlucoScreeningScreen(userData: userData));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A998E),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Mulai Screening Sekarang',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
