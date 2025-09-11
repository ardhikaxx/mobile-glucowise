import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/services/auth_services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KodeIdentitasScreen extends StatefulWidget {
  const KodeIdentitasScreen({super.key});

  @override
  State<KodeIdentitasScreen> createState() => _KodeIdentitasScreenState();
}

class _KodeIdentitasScreenState extends State<KodeIdentitasScreen> {
  late Future<UserData?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadProfileData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<UserData?> _loadProfileData() async {
    try {
      final data = await AuthServices().getProfile();
      return data;
    } catch (e) {
      print("Error loading profile data: $e");
      return null;
    }
  }

  String _formatUserDataForQR(UserData user) {
    final Map<String, dynamic> userData = {
      'nik': user.nik,
      'nama_lengkap': user.namaLengkap,
      'email': user.email,
      'tempat_lahir': user.tempatLahir ?? '',
      'tanggal_lahir': user.tanggalLahir ?? '',
      'jenis_kelamin': user.jenisKelamin ?? '',
      'alamat_lengkap': user.alamatLengkap ?? '',
      'nomor_telepon': user.nomorTelepon ?? '',
      'nama_ibu_kandung': user.namaIbuKandung ?? '',
    };

    return userData.entries
        .where((entry) => entry.value.isNotEmpty)
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        title: const Text(
          'Kode Identitas',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
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
        child: FutureBuilder<UserData?>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: const Color(0xFF199A8E),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Memuat data identitas...',
                      style: TextStyle(
                        color: Color(0xFF199A8E),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FDFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE8F3F1),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.exclamationCircle,
                          size: 32,
                          color: Color(0xFF199A8E),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Gagal Memuat Data Identitas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF199A8E),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Terjadi kesalahan saat memuat data identitas. Silakan coba lagi nanti.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF199A8E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              _userDataFuture = _loadProfileData();
                            });
                          },
                          child: const Text(
                            'Coba Lagi',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final UserData user = snapshot.data!;
            final String qrData = _formatUserDataForQR(user);

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Kode Identitas Digital',
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: 'DarumadropOne',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF199A8E),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center, // rata tengah
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFA0E7DE),
                                        Color(0xFF199A8E),
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.userAlt,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.namaLengkap,
                                      style: const TextStyle(
                                        color: Color(0xFF199A8E),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      user.nik,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // QR Code
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(24), // lebih bulat
                                border: Border.all(
                                  color: const Color(0xFFE8F3F1),
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: QrImageView(
                                  data: qrData,
                                  version: QrVersions.auto,
                                  size: 250,
                                  backgroundColor: Colors.white,
                                  eyeStyle: const QrEyeStyle(
                                    eyeShape: QrEyeShape.circle,
                                    color: Color(0xFF199A8E),
                                  ),
                                  dataModuleStyle: const QrDataModuleStyle(
                                    dataModuleShape: QrDataModuleShape.circle,
                                    color: Color(0xFF199A8E),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),
                            const Text(
                              'QR code ini berisi informasi identitas pribadi Anda',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF8D8D8D),
                                fontStyle: FontStyle.italic,
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
      ),
    );
  }
}
