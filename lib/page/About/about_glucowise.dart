import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/page/About/privasi.dart';
import 'package:medical_app/page/About/syarat_ketentuan.dart'; // Import baru

class AboutGlucoWisePage extends StatelessWidget {
  const AboutGlucoWisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        title: const Text(
          "Tentang",
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            fontWeight: FontWeight.bold,
            color: Color(0xFF199A8E),
            fontSize: 35,
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FBFA),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF199A8E).withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset("assets/logo.png", width: 55, height: 55),
                ),
                const SizedBox(height: 8),
                const Text(
                  "GlucoWise Mobile",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'DarumadropOne',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF199A8E),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Aplikasi pendamping untuk deteksi dini dan pengelolaan diabetes",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Content Section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // Pemberitahuan Privasi
                _buildExpansionTile(
                  icon: FontAwesomeIcons.shieldAlt,
                  title: "Pemberitahuan Privasi",
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Kami sangat memprioritaskan privasi data kesehatan Anda. Semua informasi yang Anda berikan dilindungi dengan enkripsi tingkat tinggi.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => PrivacyPolicyPage());
                            },
                            child: const Text(
                              "Cek Pemberitahuan Privasi",
                              style: TextStyle(
                                color: Color(0xFF199A8E),
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF199A8E),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),

                // Syarat & Ketentuan
                _buildExpansionTile(
                  icon: FontAwesomeIcons.fileAlt,
                  title: "Syarat & Ketentuan",
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Dengan menggunakan aplikasi GlucoWise Mobile, Anda menyetujui semua syarat dan ketentuan yang berlaku. Pastikan untuk membaca dan memahami ketentuan penggunaan aplikasi kami.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => TermsConditionsPage());
                        },
                        child: const Text(
                          "Baca syarat & ketentuan penggunaan aplikasi GlucoWise Mobile di sini.",
                          style: TextStyle(
                            color: Color(0xFF199A8E),
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF199A8E),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),

                _buildExpansionTile(
                  icon: FontAwesomeIcons.headset,
                  title: "Kontak Kami",
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildContactItem(
                            icon: FontAwesomeIcons.envelope,
                            text: "Email: support@glucowise.com",
                          ),
                          const SizedBox(height: 12),
                          _buildContactItem(
                            icon: FontAwesomeIcons.phone,
                            text: "Telepon: +62 812 3456 7890",
                          ),
                          const SizedBox(height: 12),
                          _buildContactItem(
                            icon: FontAwesomeIcons.mapMarkerAlt,
                            text: "Alamat: Jl. Kesehatan No. 123, Jakarta",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),

                // Versi Aplikasi
                _buildExpansionTile(
                  icon: FontAwesomeIcons.mobileAlt,
                  title: "Versi Aplikasi",
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Versi 1.0.0",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF199A8E),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Terakhir diperbarui: 12 November 2023",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: const Color(0xFF199A8E)),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF199A8E),
          ),
        ),
        children: children,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        collapsedIconColor: const Color(0xFF199A8E),
        iconColor: const Color(0xFF199A8E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildContactItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF199A8E),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}