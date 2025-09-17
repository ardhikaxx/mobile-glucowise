import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/page/GlucoCheck/all_check.dart';
import 'package:medical_app/page/GlucoCheck/detail_check.dart';
import 'package:medical_app/page/GlucoCheck/form_check.dart';
import 'package:medical_app/services/check_services.dart';

class GlucoCheckScreen extends StatefulWidget {
  final UserData userData;
  const GlucoCheckScreen({super.key, required this.userData});

  @override
  State<GlucoCheckScreen> createState() => _GlucoCheckScreenState();
}

class _GlucoCheckScreenState extends State<GlucoCheckScreen> {
  List<dynamic> checkData = [];
  bool isLoading = true;
  bool _isMounted = false;
  Map<int, Map<String, dynamic>> _statusCache = {};

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _initializeDateFormat();
    _loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfReturnedFromForm();
    });
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _checkIfReturnedFromForm() {
    final ModalRoute<Object?>? route = ModalRoute.of(context);
    if (route != null && route.isCurrent) {
      _loadData();
    }
  }

  void _initializeDateFormat() async {
    try {
      await initializeDateFormatting('id_ID', null);
    } catch (e) {
      debugPrint("Error initializing date formatting: $e");
    }
  }

  String _formatTanggal(String dateString) {
    try {
      if (dateString.contains(RegExp(r'[a-zA-Z]'))) {
        return dateString;
      }

      DateTime dateTime = DateTime.parse(dateString);

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
      debugPrint("Error formatting date: $e");
      return dateString;
    }
  }

  void _loadData() async {
    if (_isMounted) {
      setState(() {
        isLoading = true;
        _statusCache.clear(); // Clear cache saat refresh
      });
    }

    try {
      final data = await CheckServices.getRiwayatKesehatan(context);
      
      if (_isMounted) {
        setState(() {
          checkData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
      
      if (_isMounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadStatusRisiko(int idData) async {
    if (_statusCache.containsKey(idData)) {
      return; // Data sudah ada di cache
    }

    try {
      final statusData = await CheckServices.getStatusRisiko(context, idData);
      
      if (_isMounted && statusData != null) {
        setState(() {
          _statusCache[idData] = statusData;
        });
      }
    } catch (e) {
      debugPrint("Error loading status for id $idData: $e");
    }
  }

  String _getStatusText(Map<String, dynamic>? statusData) {
    if (statusData == null) return "Loading";
    if (statusData['kategori_risiko'] == 'Error') {
      return "Error";
    }
    return statusData['kategori_risiko'] ?? "Tidak Diketahui";
  }

  Color _getStatusColor(String status) {
    return status == "Tinggi"
        ? Colors.red
        : (status == "Sedang"
            ? Colors.orange
            : (status == "Rendah" 
                ? Colors.green 
                : (status == "Error"
                    ? Colors.grey
                    : Colors.grey)));
  }

  IconData _getStatusIcon(String status) {
    return status == "Tinggi"
        ? Iconsax.danger
        : (status == "Sedang"
            ? Iconsax.warning_2
            : (status == "Rendah" 
                ? Iconsax.tick_circle 
                : (status == "Error"
                    ? Iconsax.close_circle
                    : Iconsax.clock)));
  }

  @override
  Widget build(BuildContext context) {
    final dataTerbaru = checkData.isNotEmpty ? checkData.first : null;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Gluco Check",
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
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
                _loadData();
              },
              icon: const Icon(
                FontAwesomeIcons.refresh,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
                await _showRequirementsDialog(context);
              },
              icon: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF199A8E),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: const Color(0xFF199A8E),
                  size: 50,
                ),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Data Terbaru",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF199A8E),
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (dataTerbaru != null)
                      _buildLatestDataCard(dataTerbaru)
                    else
                      _buildNoDataCard(
                        title: "Belum ada data kesehatan",
                        subtitle: "Tambahkan data kesehatan pertama Anda",
                        icon: FontAwesomeIcons.circleExclamation,
                      ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Semua Riwayat",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF199A8E),
                          ),
                        ),
                        TextButton(
                          onPressed: checkData.isNotEmpty
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AllCheckScreen(checkData: checkData),
                                    ),
                                  ).then((value) {
                                    // Refresh data ketika kembali dari AllCheckScreen
                                    if (value == true) {
                                      _loadData();
                                    }
                                  });
                                }
                              : null,
                          child: Text(
                            "Lihat Semua",
                            style: TextStyle(
                              color: checkData.isNotEmpty
                                  ? const Color(0xFF199A8E)
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: checkData.isNotEmpty
                          ? RefreshIndicator(
                              color: const Color(0xFF199A8E),
                              onRefresh: () async {
                                _loadData();
                              },
                              child: ListView.builder(
                                itemCount: checkData.length,
                                itemBuilder: (context, index) {
                                  final data = checkData[index];
                                  return _buildHistoryItem(data);
                                },
                              ),
                            )
                          : RefreshIndicator(
                              color: const Color(0xFF199A8E),
                              onRefresh: () async {
                                _loadData();
                              },
                              child: _buildNoDataCard(
                                title: "Belum ada riwayat pemeriksaan",
                                subtitle: "Data riwayat akan muncul di sini",
                                icon: FontAwesomeIcons.history,
                                isSmall: true,
                              ),
                            ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 100),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLatestDataCard(Map<String, dynamic> data) {
    final int idData = data["id_data"];
    
    // Load status jika belum ada di cache
    if (!_statusCache.containsKey(idData)) {
      _loadStatusRisiko(idData);
    }
    
    final statusData = _statusCache[idData];
    final status = _getStatusText(statusData);
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

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
                      if (status == "Loading")
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: statusColor,
                          ),
                        )
                      else
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
  }

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

  Widget _buildHistoryItem(Map<String, dynamic> data) {
    final int idData = data["id_data"];
    
    // Load status jika belum ada di cache
    if (!_statusCache.containsKey(idData)) {
      _loadStatusRisiko(idData);
    }
    
    final statusData = _statusCache[idData];
    final status = _getStatusText(statusData);
    final statusColor = _getStatusColor(status);

    return Card(
      color: Color(0xFFE8F5F4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GlucoCheckDetailScreen(
                checkData: data,
                userData: widget.userData,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  FontAwesomeIcons.fileMedical,
                  color: const Color(0xFF199A8E),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatTanggal(data["tanggal_pemeriksaan"]),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Gula Darah: ${data["gula_darah"]} mg/dL",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: status == "Loading"
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: statusColor,
                        ),
                      )
                    : Text(
                        status,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoDataCard({
    required String title,
    required String subtitle,
    required IconData icon,
    bool isSmall = false,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Color(0xFFF8FDFC),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE8F3F1),
          width: 1.5,
        ),
      ),
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
            child: Icon(
              icon,
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmall ? 16 : 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF199A8E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmall ? 13 : 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          if (!isSmall) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF199A8E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  await _showRequirementsDialog(context);
                },
                child: const Text(
                  "Tambah Data Sekarang",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5, right: 8),
            child: Icon(
              Icons.circle,
              size: 10,
              color: Color(0xFF199A8E),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showRequirementsDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          "Persyaratan Tes Gula Darah Puasa (GDP)",
          style: TextStyle(
            color: Color(0xFF199A8E),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pastikan Anda telah memenuhi persyaratan berikut:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildRequirementItem(
                "Tidak makan atau minum (selain air putih) selama 8 jam sebelum tes"),
            _buildRequirementItem(
                "Biasanya dilakukan pagi hari, sebelum sarapan"),
            const SizedBox(height: 10),
            const Text(
              "Tujuan: Menilai kadar gula darah tanpa pengaruh makanan.",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Batal",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF199A8E),
            ),
            onPressed: () {
              Get.back();
              _navigateToForm(context);
            },
            child: const Text(
              "Saya Mengerti",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToForm(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GlucoCheckForm()),
    );

    if (result == true && _isMounted) {
      _loadData();
    }
  }
}