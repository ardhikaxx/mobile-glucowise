import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medical_app/services/check_services.dart';
import 'package:medical_app/model/user.dart';
import 'package:shimmer/shimmer.dart';

class GlucoCheckDetailScreen extends StatefulWidget {
  final Map<String, dynamic> checkData;
  final UserData userData;
  
  const GlucoCheckDetailScreen({
    super.key,
    required this.checkData,
    required this.userData,
  });

  @override
  State<GlucoCheckDetailScreen> createState() => _GlucoCheckDetailScreenState();
}

class _GlucoCheckDetailScreenState extends State<GlucoCheckDetailScreen> {
  Map<String, dynamic>? statusData;
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadStatusData();
  }

  void _loadStatusData() async {
    try {
      final data = await CheckServices.getStatusRisiko(
        context, 
        widget.checkData["id_data"]
      );
      
      if (mounted) {
        setState(() {
          statusData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading status data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String _formatTanggal(String dateString) {
    try {
      if (dateString.contains(RegExp(r'[a-zA-Z]'))) {
        return dateString;
      }

      DateTime dateTime = DateTime.parse(dateString);
      List<String> bulan = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];

      return '${dateTime.day} ${bulan[dateTime.month - 1]} ${dateTime.year}';
    } catch (e) {
      return dateString;
    }
  }

  Color _getStatusColor(String status) {
    return status == "Tinggi"
        ? const Color(0xFFE53935)
        : (status == "Sedang"
            ? const Color(0xFFFF9800)
            : (status == "Rendah" ? const Color(0xFF4CAF50) : Colors.grey));
  }

  IconData _getStatusIcon(String status) {
    return status == "Tinggi"
        ? Iconsax.danger
        : (status == "Sedang"
            ? Iconsax.warning_2
            : (status == "Rendah"
                ? Iconsax.tick_circle
                : Iconsax.clock));
  }

  String _getStatusDescription(String status) {
    return status == "Tinggi"
        ? "Anda memiliki risiko diabetes yang tinggi. Disarankan untuk berkonsultasi dengan dokter."
        : (status == "Sedang"
            ? "Anda memiliki risiko diabetes sedang. Perhatikan pola makan dan gaya hidup sehat."
            : (status == "Rendah"
                ? "Risiko diabetes Anda rendah. Pertahankan gaya hidup sehat Anda!"
                : "Status risiko belum dapat ditentukan."));
  }

  Widget _buildInfoCard(IconData icon, String value, String label, Color color, {String? unit}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
                height: 1.2,
              ),
              children: unit != null
                  ? [
                      TextSpan(
                        text: ' $unit',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: color.withOpacity(0.7),
                        ),
                      )
                    ]
                  : [],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }

    final status = statusData?["kategori_risiko"] ?? "Tidak Diketahui";
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);
    final description = _getStatusDescription(status);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  statusIcon,
                  size: 24,
                  color: statusColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status Risiko Diabetes",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceSection() {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }

    final catatan = statusData?["catatan"] ?? "Tidak ada catatan tenaga kesehatan tersedia saat ini.";
    final status = statusData?["kategori_risiko"] ?? "Tidak Diketahui";
    final statusColor = _getStatusColor(status);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Iconsax.lamp_charge,
                  size: 20,
                  color: statusColor,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Catatan Kesehatan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            catatan,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          if (status == "Tinggi" || status == "Sedang")
            ElevatedButton(
              onPressed: () {
                // Aksi untuk mencari dokter
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: statusColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text("Konsultasi dengan Dokter"),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF199A8E),
                  Color(0xFF2DC8B9),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              FontAwesomeIcons.calendarDay,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tanggal Pemeriksaan",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTanggal(widget.checkData["tanggal_pemeriksaan"]),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF199A8E),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFamilyHistory() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF199A8E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              FontAwesomeIcons.userGroup,
              color: Color(0xFF199A8E),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Riwayat Keluarga Diabetes",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.checkData["riwayat_keluarga_diabetes"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF199A8E),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FDFC),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Detail Pemeriksaan',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),
                    _buildStatusIndicator(),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                      children: [
                        _buildInfoCard(
                          FontAwesomeIcons.ruler,
                          widget.checkData["tinggi_badan"].toString(),
                          "Tinggi Badan",
                          const Color(0xFF2196F3),
                          unit: "cm",
                        ),
                        _buildInfoCard(
                          FontAwesomeIcons.weightScale,
                          widget.checkData["berat_badan"].toString(),
                          "Berat Badan",
                          const Color(0xFF4CAF50),
                          unit: "kg",
                        ),
                        _buildInfoCard(
                          FontAwesomeIcons.droplet,
                          widget.checkData["gula_darah"].toString(),
                          "Gula Darah",
                          const Color(0xFFF44336),
                          unit: "mg/dL",
                        ),
                        _buildInfoCard(
                          FontAwesomeIcons.heartPulse,
                          widget.checkData["tensi_darah"].toString(),
                          "Tensi Darah",
                          const Color(0xFF9C27B0),
                          unit: "mmHg",
                        ),
                        _buildInfoCard(
                          FontAwesomeIcons.rulerCombined,
                          widget.checkData["lingkar_pinggang"].toString(),
                          "Lingkar Pinggang",
                          const Color(0xFFFF9800),
                          unit: "cm",
                        ),
                        _buildInfoCard(
                          FontAwesomeIcons.userClock,
                          widget.checkData["umur"].toString(),
                          "Umur",
                          const Color(0xFF607D8B),
                          unit: "tahun",
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFamilyHistory(),
                    const SizedBox(height: 16),
                    _buildAdviceSection(),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}