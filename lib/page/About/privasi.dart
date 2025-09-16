import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        title: const Text(
          "Pemberitahuan Privasi",
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            fontWeight: FontWeight.bold,
            color: Color(0xFF199A8E),
            fontSize: 28,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFFEEBA),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    FontAwesomeIcons.exclamationTriangle,
                    color: Color(0xFF856404),
                    size: 20,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "PENTING",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF856404),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Mohon baca seluruh pemberitahuan privasi dengan cermat sebelum menggunakan fitur dan layanan GlucoWise Mobile.",
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF856404).withOpacity(0.9),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(
              icon: FontAwesomeIcons.fileContract,
              title: "Ketentuan Umum",
            ),

            const SizedBox(height: 10),

            _buildPrivacyCard(
              number: "1.1",
              title: "Pemberitahuan Privasi",
              content:
                  "Pemberitahuan Privasi ini adalah perjanjian antara pengguna (\"Pengguna\") dan Kementerian Kesehatan Republik Indonesia selaku Penyelenggara Sistem Elektronik GlucoWise Mobile (\"GlucoWise\").",
              icon: FontAwesomeIcons.handshake,
            ),

            _buildPrivacyCard(
              number: "1.2",
              title: "Bagian dari Syarat dan Ketentuan",
              content:
                  "Pemberitahuan Privasi ini merupakan bagian dari Syarat dan Ketentuan Penggunaan. Dengan menggunakan GlucoWise, Pengguna dianggap setuju untuk terikat dengan ketentuan Pemberitahuan Privasi ini.",
              icon: FontAwesomeIcons.fileAlt,
            ),

            _buildPrivacyCard(
              number: "1.3",
              title: "Penolakan",
              content:
                  "Apabila Pengguna tidak setuju terhadap salah satu, sebagian, atau seluruh isi yang tertuang dalam Pemberitahuan Privasi ini, maka Pengguna diperkenankan untuk menghapus GlucoWise dalam perangkat elektronik dan/atau tidak mengakses aplikasi.",
              icon: FontAwesomeIcons.timesCircle,
            ),

            const SizedBox(height: 10),

            _buildSectionHeader(
              icon: FontAwesomeIcons.database,
              title: "Data yang Kami Kumpulkan",
            ),

            const SizedBox(height: 16),

            _buildPrivacyCard(
              number: "2.1",
              title: "Data Kesehatan",
              content:
                  "GlucoWise mengumpulkan data kesehatan yang Anda input melalui fitur GlucoCheck, termasuk riwayat keluarga diabetes, umur, tinggi badan, berat badan, hasil cek gula darah, lingkar pinggang, dan tensi darah.",
              icon: FontAwesomeIcons.heartbeat,
            ),

            _buildPrivacyCard(
              number: "2.2",
              title: "Data Screening",
              content:
                  "Kami menyimpan hasil tes screening diabetes Anda beserta poin dan indikasi risiko yang dihasilkan (rendah, sedang, tinggi).",
              icon: FontAwesomeIcons.clipboardCheck,
            ),

            _buildPrivacyCard(
              number: "2.3",
              title: "Data Pengingat Obat",
              content:
                  "GlucoWise menyimpan informasi jadwal minum obat dan makan setelah minum obat yang Anda atur melalui fitur GlucoCare.",
              icon: FontAwesomeIcons.pills,
            ),

            const SizedBox(height: 10),

            _buildSectionHeader(
              icon: FontAwesomeIcons.chartLine,
              title: "Penggunaan Data",
            ),

            const SizedBox(height: 10),

            _buildPrivacyCard(
              number: "3.1",
              title: "Tujuan Medis",
              content:
                  "Data kesehatan Anda digunakan untuk memberikan rekomendasi personal terkait pola makan, aktivitas fisik, serta tips gaya hidup sehat melalui fitur Glucozia AI.",
              icon: FontAwesomeIcons.stethoscope,
            ),

            _buildPrivacyCard(
              number: "3.2",
              title: "Edukasi",
              content:
                  "Data digunakan untuk menyediakan konten edukasi yang relevan dengan kondisi kesehatan dan kebutuhan Anda.",
              icon: FontAwesomeIcons.graduationCap,
            ),

            _buildPrivacyCard(
              number: "3.3",
              title: "Pengembangan Layanan",
              content:
                  "Data anonim dapat digunakan untuk pengembangan dan peningkatan kualitas layanan GlucoWise.",
              icon: FontAwesomeIcons.rocket,
            ),

            const SizedBox(height: 10),

            _buildSectionHeader(
              icon: FontAwesomeIcons.shieldAlt,
              title: "Keamanan Data",
            ),

            const SizedBox(height: 10),

            _buildPrivacyCard(
              number: "4.1",
              title: "Enkripsi",
              content:
                  "Semua data kesehatan Anda dilindungi dengan enkripsi tingkat tinggi selama proses transmisi dan penyimpanan.",
              icon: FontAwesomeIcons.lock,
            ),

            _buildPrivacyCard(
              number: "4.2",
              title: "Akses Terbatas",
              content:
                  "Hanya tenaga kesehatan yang berwenang dan Anda sendiri yang dapat mengakses data kesehatan pribadi.",
              icon: FontAwesomeIcons.userShield,
            ),

            _buildPrivacyCard(
              number: "4.3",
              title: "Penyimpanan Data",
              content:
                  "Data disimpan di server yang aman dengan protokol keamanan tinggi dan backup data berkala.",
              icon: FontAwesomeIcons.server,
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF199A8E).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF199A8E),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.checkCircle, size: 20),
                    SizedBox(width: 12),
                    Text(
                      "Saya Mengerti & Setuju",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF199A8E),
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF199A8E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard({
    required String number,
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFE8F4F3),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF199A8E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: const Color(0xFF199A8E),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF199A8E),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        number,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
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
