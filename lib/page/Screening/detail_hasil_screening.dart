import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/model/screening_detail.dart';
import 'package:medical_app/services/screening_services.dart';

class DetailHasilScreeningScreen extends StatefulWidget {
  final int screeningId;

  const DetailHasilScreeningScreen({super.key, required this.screeningId});

  @override
  State<DetailHasilScreeningScreen> createState() =>
      _DetailHasilScreeningScreenState();
}

class _DetailHasilScreeningScreenState
    extends State<DetailHasilScreeningScreen> {
  ScreeningDetail? screeningDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadScreeningDetail();
  }

  Future<void> _loadScreeningDetail() async {
    final detail =
        await ScreeningServices.getScreeningDetail(widget.screeningId);
    if (detail != null && detail['success'] == true) {
      setState(() {
        screeningDetail = ScreeningDetail.fromJson(detail['data']);
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

  String _getIndikasiLevel(int score) {
    if (score <= 7) return 'Indikasi Rendah';
    if (score <= 14) return 'Indikasi Sedang';
    return 'Indikasi Tinggi';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Detail Screening',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 30,
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
            : screeningDetail == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Gagal memuat detail screening',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6C757D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _loadScreeningDetail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF199A8E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                          child: const Text(
                            'Coba Lagi',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Result Summary Card
                        Container(
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
                                decoration: BoxDecoration(
                                  color: Color(0xFF199A8E),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'SCREENING #${screeningDetail!.idScreening}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white.withOpacity(0.9),
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    Text(
                                      screeningDetail!.formattedDate,
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
                                                _getRiskColor(screeningDetail!
                                                        .skorRisiko)
                                                    .withOpacity(0.15),
                                                _getRiskColor(screeningDetail!
                                                        .skorRisiko)
                                                    .withOpacity(0.05),
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
                                              color: _getRiskColor(
                                                  screeningDetail!.skorRisiko),
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
                                                  '${screeningDetail!.skorRisiko}',
                                                  style: TextStyle(
                                                    fontSize: 42,
                                                    fontWeight: FontWeight.bold,
                                                    color: _getRiskColor(
                                                        screeningDetail!
                                                            .skorRisiko),
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Skor',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: _getRiskColor(
                                                            screeningDetail!
                                                                .skorRisiko)
                                                        .withOpacity(0.8),
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
                                        color: _getRiskColor(
                                                screeningDetail!.skorRisiko)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        _getIndikasiLevel(
                                            screeningDetail!.skorRisiko),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: _getRiskColor(
                                              screeningDetail!.skorRisiko),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    // Description
                                    Text(
                                      _getIndikasiDescription(
                                          screeningDetail!.skorRisiko),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.medical_services,
                                                color: _getRiskColor(
                                                    screeningDetail!
                                                        .skorRisiko),
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Rekomendasi',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: _getRiskColor(
                                                      screeningDetail!
                                                          .skorRisiko),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            _getIndikasiRecommendation(
                                                screeningDetail!.skorRisiko),
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
                        const SizedBox(height: 24),
                        // Answers Section
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.assignment,
                                    color: const Color(0xFF199A8E),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Detail Jawaban',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF199A8E),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Total pertanyaan: ${screeningDetail!.hasilScreening.length}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6C757D),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: screeningDetail!.hasilScreening.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final item = screeningDetail!.hasilScreening[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: theme.primaryColor
                                                .withOpacity(0.1),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: theme.primaryColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            item.pertanyaan,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Color(0xFF495057),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 40),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF8F9FA),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(0.1),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color: theme.primaryColor
                                                    .withOpacity(0.1),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.check,
                                                size: 14,
                                                color: theme.primaryColor,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                item.jawaban,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF495057),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
