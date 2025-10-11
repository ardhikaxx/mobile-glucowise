import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:medical_app/services/check_services.dart';
import 'package:intl/date_symbol_data_local.dart';

class AllCheckScreen extends StatefulWidget {
  final List checkData;
  const AllCheckScreen({super.key, required this.checkData});

  @override
  State<AllCheckScreen> createState() => _AllCheckScreenState();
}

class _AllCheckScreenState extends State<AllCheckScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeDateFormat();
  }

  void _initializeDateFormat() async {
    try {
      await initializeDateFormatting('id_ID', null);
    } catch (e) {
      print("Error initializing date formatting: $e");
    }
  }

  String _formatTanggal(String dateString) {
    try {
      // Cek jika tanggal sudah dalam format yang diinginkan
      if (dateString.contains(RegExp(r'[a-zA-Z]'))) {
        return dateString;
      }

      // Parse tanggal
      DateTime dateTime = DateTime.parse(dateString);

      // Format manual ke bahasa Indonesia
      List<String> bulan = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];

      return '${dateTime.day} ${bulan[dateTime.month - 1]} ${dateTime.year}';
    } catch (e) {
      print("Error formatting date: $e");
      return dateString; // Return original string jika parsing gagal
    }
  }

  // Fungsi untuk membangun card data terbaru (diambil dari gluco_check.dart)
  Widget _buildLatestDataCard(Map<String, dynamic> data) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: CheckServices.getStatusRisiko(context, data["id_data"]),
      builder: (context, snapshot) {
        final statusData = snapshot.data;
        final status = statusData?["kategori_risiko"] ?? "Loading";
        final statusColor = status == "Tinggi"
            ? Colors.red
            : (status == "Sedang"
                ? Colors.orange
                : (status == "Rendah" ? Colors.green : Colors.grey));

        final statusIcon = status == "Tinggi"
            ? Iconsax.danger
            : (status == "Sedang"
                ? Iconsax.warning_2
                : (status == "Rendah" ? Iconsax.tick_circle : Iconsax.clock));

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFFE8F5F4),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF199A8E).withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF199A8E).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            FontAwesomeIcons.calendarDay,
                            color: Color(0xFF199A8E),
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _formatTanggal(data["tanggal_pemeriksaan"]),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF199A8E),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            statusIcon,
                            size: 16,
                            color: statusColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF199A8E).withOpacity(0.2),
                        const Color(0xFF199A8E).withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2.8,
                  children: [
                    _buildInfoCard(
                      FontAwesomeIcons.ruler,
                      "${data["tinggi_badan"]} cm",
                      "Tinggi Badan",
                      const Color(0xFF199A8E),
                    ),
                    _buildInfoCard(
                      FontAwesomeIcons.weightScale,
                      "${data["berat_badan"]} kg",
                      "Berat Badan",
                      const Color(0xFF199A8E),
                    ),
                    _buildInfoCard(
                      FontAwesomeIcons.droplet,
                      "${data["gula_darah"]} mg/dL",
                      "Gula Darah",
                      const Color(0xFF199A8E),
                    ),
                    _buildInfoCard(
                      FontAwesomeIcons.heartPulse,
                      data["tensi_darah"].toString(),
                      "Tensi Darah",
                      const Color(0xFF199A8E),
                    ),
                    _buildInfoCard(
                      FontAwesomeIcons.rulerCombined,
                      "${data["lingkar_pinggang"]} cm",
                      "Lingkar Pinggang",
                      const Color(0xFF199A8E),
                    ),
                    _buildInfoCard(
                      FontAwesomeIcons.userClock,
                      "${data["umur"]} tahun",
                      "Umur",
                      const Color(0xFF199A8E),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Riwayat Keluarga
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF199A8E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.userGroup,
                          color: Color(0xFF199A8E),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Riwayat Keluarga",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              data["riwayat_keluarga_diabetes"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF199A8E),
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
        );
      },
    );
  }

  // Fungsi untuk membangun info card (diambil dari gluco_check.dart)
  Widget _buildInfoCard(
      IconData icon, String value, String label, Color color) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Semua Riwayat',
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
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF199A8E)))
            : widget.checkData.isEmpty
                ? const Center(
                    child: Text(
                      "Tidak ada data riwayat kesehatan.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    itemCount: widget.checkData.length,
                    itemBuilder: (context, index) {
                      final data = widget.checkData[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: _buildLatestDataCard(data),
                      );
                    },
                  ),
      ),
    );
  }
}
