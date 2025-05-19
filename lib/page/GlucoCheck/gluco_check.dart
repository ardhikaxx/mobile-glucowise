import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/page/GlucoCheck/all_check.dart';
import 'package:medical_app/page/GlucoCheck/form_check.dart';
import 'package:medical_app/services/check_services.dart';
import 'package:medical_app/components/navbottom.dart';
import 'package:get/get.dart';

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

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _loadData();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  void _loadData() async {
    if (_isMounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final data = await CheckServices.getRiwayatKesehatan(context);
      await Future.delayed(const Duration(seconds: 1));

      if (_isMounted) {
        setState(() {
          checkData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading data: $e");
      await Future.delayed(const Duration(seconds: 1));

      if (_isMounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () async {
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
                        onPressed: () => Navigator.pop(context),
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
                          Navigator.pop(context);
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
                    const Text(
                      "Data Terbaru",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF199A8E),
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
                    if (dataTerbaru != null)
                      _buildLatestDataCard(dataTerbaru)
                    else
                      _buildNoDataCard(
                        title: "Belum ada data kesehatan",
                        subtitle: "Tambahkan data kesehatan pertama Anda",
                        icon: FontAwesomeIcons.circleExclamation,
                      ),
                    const SizedBox(height: 20),
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
                                  );
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
                    const SizedBox(height: 10),
                    Expanded(
                      child: checkData.isNotEmpty
                          ? ListView.builder(
                              itemCount: checkData.length,
                              itemBuilder: (context, index) {
                                final data = checkData[index];
                                return _buildHistoryItem(data);
                              },
                            )
                          : _buildNoDataCard(
                              title: "Belum ada riwayat pemeriksaan",
                              subtitle: "Data riwayat akan muncul di sini",
                              icon: FontAwesomeIcons.history,
                              isSmall: true,
                            ),
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLatestDataCard(Map<String, dynamic> data) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              const Color(0xFFE8F5F4).withOpacity(0.6),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(FontAwesomeIcons.calendarDay,
                          color: Color(0xFF199A8E), size: 20),
                      const SizedBox(width: 10),
                      Text(
                        data["tanggal_pemeriksaan"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Icon(FontAwesomeIcons.fileMedical,
                      color: Color(0xFF199A8E), size: 20),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(
                color: Color(0xFF199A8E),
                thickness: 0.8,
              ),
              const SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
                children: [
                  _infoItem(FontAwesomeIcons.ruler,
                      "${data["tinggi_badan"]} cm", "Tinggi Badan"),
                  _infoItem(FontAwesomeIcons.weightScale,
                      "${data["berat_badan"]} kg", "Berat Badan"),
                  _infoItem(FontAwesomeIcons.droplet,
                      "${data["gula_darah"]} mg/dL", "Gula Darah"),
                  _infoItem(FontAwesomeIcons.heartPulse,
                      data["tensi_darah"].toString(), "Tensi"),
                  _infoItem(FontAwesomeIcons.ruler,
                      "${data["lingkar_pinggang"]} cm", "Lingkar Pinggang"),
                  _infoItem(FontAwesomeIcons.userClock, "${data["umur"]} tahun",
                      "Umur"),
                  _infoItem(FontAwesomeIcons.userGroup,
                      data["riwayat_keluarga_diabetes"], "Riwayat Keluarga"),
                  FutureBuilder<Map<String, dynamic>?>(
                    future:
                        CheckServices.getStatusRisiko(context, data["id_data"]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Color(0xFF199A8E),
                        ));
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text("Gagal memuat status risiko"));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text("Tidak ada data"));
                      }

                      final status = snapshot.data!;
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              status["kategori_risiko"] == "Tinggi"
                                  ? FontAwesomeIcons.solidFaceFrown
                                  : (status["kategori_risiko"] == "Sedang"
                                      ? FontAwesomeIcons.faceMeh
                                      : (status["kategori_risiko"] == "Rendah"
                                          ? FontAwesomeIcons.solidFaceSmile
                                          : FontAwesomeIcons.clock)),
                              color: status["kategori_risiko"] == "Tinggi"
                                  ? Colors.red
                                  : (status["kategori_risiko"] == "Sedang"
                                      ? Colors.orange
                                      : (status["kategori_risiko"] == "Rendah"
                                          ? Colors.green
                                          : Colors.grey)),
                              size: 24,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Status Risiko",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black87),
                                ),
                                Text(
                                  status["kategori_risiko"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: status["kategori_risiko"] == "Tinggi"
                                        ? Colors.red
                                        : (status["kategori_risiko"] == "Sedang"
                                            ? Colors.orange
                                            : (status["kategori_risiko"] ==
                                                    "Rendah"
                                                ? Colors.green
                                                : Colors.grey)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> data) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: FutureBuilder<Map<String, dynamic>?>(
        future: CheckServices.getStatusRisiko(context, data["id_data"]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ListTile(
              title: Text("Memuat..."),
              trailing: CircularProgressIndicator(
                color: Color(0xFF199A8E),
              ),
            );
          } else if (snapshot.hasError) {
            return const ListTile(
              title: Text("Error memuat data"),
            );
          } else if (!snapshot.hasData) {
            return const ListTile(
              title: Text("Tidak ada data"),
            );
          }

          final status = snapshot.data!;
          final statusColor = status["kategori_risiko"] == "Tinggi"
              ? Colors.red
              : (status["kategori_risiko"] == "Sedang"
                  ? Colors.orange
                  : (status["kategori_risiko"] == "Rendah"
                      ? Colors.green
                      : Colors.black45));

          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5F4),
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
                          data["tanggal_pemeriksaan"],
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
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: statusColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      status["kategori_risiko"],
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
          );
        },
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
                onPressed: () => _navigateToForm(context),
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

  Widget _infoItem(IconData icon, String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF199A8E), size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ],
          ),
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
