import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        title: const Text(
          "Syarat & Ketentuan",
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
                          "Mohon baca seluruh syarat dan ketentuan penggunaan dengan cermat sebelum menggunakan fitur dan layanan GlucoWise Mobile.",
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
            
            // Content Section
            _buildSectionHeader(
              icon: FontAwesomeIcons.fileContract,
              title: "Ketentuan Umum",
            ),
            
            const SizedBox(height: 10),
            
            _buildTermCard(
              number: "1.1",
              title: "Syarat dan Ketentuan Penggunaan",
              content: "Syarat dan Ketentuan Penggunaan ini adalah perjanjian antara pengguna (\"Pengguna\") dan Kementerian Kesehatan Republik Indonesia selaku Penyelenggara Sistem Elektronik GlucoWise Mobile (\"GlucoWise\"). Syarat dan Ketentuan Penggunaan ini juga mengatur pengelolaan Data Pribadi pada GlucoWise.",
              icon: FontAwesomeIcons.fileAlt,
            ),
            
            _buildTermCard(
              number: "1.2",
              title: "Ketentuan Penggunaan Tambahan",
              content: "Dengan menyetujui Syarat dan Ketentuan Penggunaan ini, Pengguna juga menyetujui ketentuan penggunaan tambahan pada GlucoWise dan perubahannya yang merupakan bagian yang tidak terpisahkan dari Syarat dan Ketentuan Penggunaan ini (\"Ketentuan Penggunaan Tambahan\").",
              icon: FontAwesomeIcons.fileSignature,
            ),
            
            _buildTermCard(
              number: "1.3",
              title: "Penolakan",
              content: "Apabila Pengguna tidak setuju terhadap salah satu, sebagian, atau seluruh isi yang tertuang dalam Syarat dan Ketentuan Penggunaan ini, maka Pengguna diperkenankan untuk menghapus GlucoWise dalam perangkat elektronik dan/atau tidak mengakses aplikasi.",
              icon: FontAwesomeIcons.timesCircle,
            ),
            
            const SizedBox(height: 10),
            
            _buildSectionHeader(
              icon: FontAwesomeIcons.userCheck,
              title: "Persetujuan Pengguna",
            ),
            
            const SizedBox(height: 10),
            
            _buildTermCard(
              number: "2.1",
              title: "Kewajiban Pengguna",
              content: "Pengguna wajib memberikan informasi yang akurat dan lengkap saat mendaftar dan menggunakan layanan GlucoWise Mobile. Informasi yang tidak akurat dapat mempengaruhi kualitas layanan yang diberikan.",
              icon: FontAwesomeIcons.userAlt,
            ),
            
            _buildTermCard(
              number: "2.2",
              title: "Penggunaan yang Bertanggung Jawab",
              content: "Pengguna bertanggung jawab penuh atas segala aktivitas yang dilakukan melalui akun GlucoWise Mobile. Pengguna wajib menjaga kerahasiaan informasi akun dan kata sandi.",
              icon: FontAwesomeIcons.shieldAlt,
            ),
            
            _buildTermCard(
              number: "2.3",
              title: "Kepatuhan Hukum",
              content: "Pengguna wajib mematuhi semua peraturan perundang-undangan yang berlaku dalam penggunaan layanan GlucoWise Mobile dan tidak menggunakan layanan untuk tujuan yang melanggar hukum.",
              icon: FontAwesomeIcons.balanceScale,
            ),
            
            const SizedBox(height: 10),
            
            _buildSectionHeader(
              icon: FontAwesomeIcons.lock,
              title: "Hak Kekayaan Intelektual",
            ),
            
            const SizedBox(height: 10),
            
            _buildTermCard(
              number: "3.1",
              title: "Kepemilikan Konten",
              content: "Seluruh konten, fitur, dan fungsi yang terdapat dalam GlucoWise Mobile, termasuk namun tidak terbatas pada teks, grafis, logo, dan gambar, merupakan hak milik Kementerian Kesehatan Republik Indonesia dan dilindungi oleh hukum hak cipta.",
              icon: FontAwesomeIcons.copyright,
            ),
            
            _buildTermCard(
              number: "3.2",
              title: "Pembatasan Penggunaan",
              content: "Pengguna dilarang melakukan reproduksi, duplikasi, menyalin, menjual, atau mengeksploitasi bagian mana pun dari GlucoWise Mobile tanpa izin tertulis dari Kementerian Kesehatan Republik Indonesia.",
              icon: FontAwesomeIcons.ban,
            ),
            
            const SizedBox(height: 10),
            
            _buildSectionHeader(
              icon: FontAwesomeIcons.exclamationTriangle,
              title: "Pembatasan Tanggung Jawab",
            ),
            
            const SizedBox(height: 10),
            
            _buildTermCard(
              number: "4.1",
              title: "Layanan \"SEBAGAIMANA ADANYA\"",
              content: "GlucoWise Mobile disediakan dalam keadaan \"sebagaimana adanya\" dan \"sesuai ketersediaan\". Kementerian Kesehatan tidak memberikan jaminan bahwa layanan akan bebas dari kesalahan atau gangguan.",
              icon: FontAwesomeIcons.infoCircle,
            ),
            
            _buildTermCard(
              number: "4.2",
              title: "Batasan Tanggung Jawab",
              content: "Kementerian Kesehatan tidak bertanggung jawab atas kerugian tidak langsung, insidental, khusus, atau konsekuensial yang timbul dari penggunaan atau ketidakmampuan menggunakan GlucoWise Mobile.",
              icon: FontAwesomeIcons.handsHelping,
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
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
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

  Widget _buildTermCard({
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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