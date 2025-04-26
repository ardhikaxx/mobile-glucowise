import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/components/navbottom.dart';
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
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy, HH:mm').format(date);
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
            fontSize: 28,
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
              onPressed: () {
                Get.offAll(() => NavBottom(userData: widget.userData));
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF1A998E)),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                mainAxisSpacing: 16,
                                childAspectRatio: 3.2,
                              ),
                              itemCount: screeningHistory.length,
                              itemBuilder: (context, index) {
                                final item = screeningHistory[index];
                                final score = item['skor_risiko'];
                                final date = _formatDate(item['tanggal_screening']);
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
                                        builder: (context) => DetailHasilScreeningScreen(
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
                                              color: riskColor.withOpacity(0.1),
                                              border: Border.all(
                                                color: riskColor.withOpacity(0.3),
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
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'ID: #${item['id_screening']}',
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black54,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 12, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: riskColor.withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      child: Text(
                                                        riskLevel,
                                                        style: TextStyle(
                                                          color: riskColor,
                                                          fontWeight: FontWeight.w600,
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
                                                  backgroundColor: Colors.grey[200],
                                                  color: riskColor,
                                                  minHeight: 6,
                                                  borderRadius: BorderRadius.circular(3),
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
    );
  }

  Widget _buildEmptyState() {
    final userData = widget.userData;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFE9F3F2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_outlined,
              size: 50,
              color: Color(0xFF1A998E),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum Ada Riwayat Screening',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A998E),
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Anda belum memiliki riwayat screening. Lakukan screening pertama untuk melihat hasilnya di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              MaterialPageRoute(
                    builder: (context) => GlucoScreeningScreen(userData: userData),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A998E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              elevation: 0,
            ),
            child: const Text(
              'Mulai Screening',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}