import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/page/About/about_glucowise.dart';
import 'package:medical_app/page/GawatDarurat/nomor_gawat_darurat.dart';
import 'package:medical_app/page/Hospital/hospital_page.dart';
import 'package:medical_app/page/UserProfile/edit_profile.dart';
import 'package:medical_app/page/UserProfile/nik_konfirmasi.dart';
// import 'package:medical_app/page/UserProfile/qr_identitas.dart';
import 'package:medical_app/services/auth_services.dart';

class UserScreen extends StatefulWidget {
  final UserData userData;
  const UserScreen({super.key, required this.userData});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<UserData?> userData;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    userData = _loadProfileData();
    initializeDateFormatting('id_ID', null);
  }

  String _formatNIK(String nik) {
    if (nik.length != 16) return '**********';

    return '${nik.substring(0, 3)}**********${nik.substring(13)}';
  }

  Future<UserData?> _loadProfileData() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final data = await AuthServices().getProfile();
      return data;
    } catch (e) {
      print("Error loading profile data: $e");
      return null;
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  bool isUserDataIncomplete(UserData user) {
    return user.namaLengkap.isEmpty ||
        user.nik.isEmpty ||
        user.email.isEmpty ||
        user.nomorTelepon == null ||
        user.nomorTelepon!.isEmpty ||
        user.alamatLengkap == null ||
        user.alamatLengkap!.isEmpty;
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
                  FontAwesomeIcons.signOutAlt,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Konfirmasi Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Apakah Anda yakin ingin keluar dari akun Anda?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: const Color(0xFF199A8E)),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: Color(0xFF199A8E),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: Get.width * 0.05),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _logout(context);
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    AuthServices().logout(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: FutureBuilder<UserData?>(
          future: userData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.inkDrop(
                  color: const Color(0xFF199A8E),
                  size: 50,
                ),
              );
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
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
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                            'Gagal Memuat Profil',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF199A8E),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Terjadi kesalahan saat memuat data profil. Silakan coba lagi nanti atau periksa koneksi internet Anda.',
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: () {
                                setState(() {
                                  userData = _loadProfileData();
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
                  ),
                ),
              );
            }
            UserData user = snapshot.data!;
            return _buildProfile(user);
          },
        ),
      ),
    );
  }

  Widget _buildProfile(UserData user) {
    final isComplete = !isUserDataIncomplete(user);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHealthHeader(user),
          const SizedBox(height: 10),
          if (!isComplete) ...[
            _buildIncompleteDataCard(),
            const SizedBox(height: 16),
          ],
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8),
            child: Text(
              'Informasi Pribadi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF199A8E),
              ),
            ),
          ),
          _buildPersonalInfoCard(user),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8),
            child: Text(
              'Pengaturan dan Layanan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF199A8E),
              ),
            ),
          ),
          _buildQuickAccessMenu(),
          const SizedBox(height: 16),
          _buildActionButtons(context),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
        ],
      ),
    );
  }

  Widget _buildHealthHeader(UserData user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF199A8E),
                      Color(0xFF23B8A9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    FontAwesomeIcons.solidUser,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.namaLengkap.isEmpty
                          ? "Tidak ada data"
                          : user.namaLengkap,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF199A8E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(FontAwesomeIcons.phone,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            user.nomorTelepon!.isEmpty
                                ? "Tidak ada data"
                                : user.nomorTelepon!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(FontAwesomeIcons.creditCardAlt,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _formatNIK(
                                user.nik.isEmpty ? "Tidak ada data" : user.nik),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    UserData? currentUserData =
                        await AuthServices().getProfile();
                    if (currentUserData != null && _isMounted) {
                      bool? isUpdated = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfileScreen(userData: currentUserData),
                        ),
                      );

                      if (isUpdated == true && _isMounted) {
                        setState(() {
                          userData = _loadProfileData();
                        });
                      }
                    }
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 43,
                    height: 43,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF199A8E),
                          Color(0xFF23B8A9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        FontAwesomeIcons.pencil,
                        size: 19,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 12),
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const DigitalIDScreen(),
          //       ),
          //     );
          //   },
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          //     decoration: BoxDecoration(
          //       color: const Color(0xFFF7FBFA),
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: Row(
          //       children: const [
          //         Icon(FontAwesomeIcons.qrcode,
          //             color: Color(0xFF199A8E), size: 20),
          //         SizedBox(width: 12),
          //         Expanded(
          //           child: Text(
          //             "GlucoID",
          //             style: TextStyle(
          //               fontSize: 15,
          //               fontWeight: FontWeight.w600,
          //               color: Color(0xFF199A8E),
          //             ),
          //           ),
          //         ),
          //         Icon(Icons.chevron_right, color: Colors.grey),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildIncompleteDataCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFEF3C7),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              FontAwesomeIcons.exclamationTriangle,
              size: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Data Tidak Lengkap',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF92400E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lengkapi profil untuk pengalaman terbaik',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              UserData? currentUserData = await AuthServices().getProfile();
              if (currentUserData != null && _isMounted) {
                bool? isUpdated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditProfileScreen(userData: currentUserData),
                  ),
                );

                if (isUpdated == true && _isMounted) {
                  setState(() {
                    userData = _loadProfileData();
                  });
                }
              }
            },
            child: const Text(
              'Lengkapi',
              style: TextStyle(
                color: Color(0xFF199A8E),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(UserData user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoItem(
            icon: FontAwesomeIcons.solidEnvelope,
            title: "Email",
            value: user.email.isEmpty ? "Tidak ada data" : user.email,
          ),
          const Divider(height: 24, color: Color(0xFFE8F3F1)),
          _buildInfoItem(
            icon: FontAwesomeIcons.locationDot,
            title: "Alamat",
            value: user.alamatLengkap ?? "Tidak ada data",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F3F1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 18,
              color: const Color(0xFF199A8E),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF101623),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessMenu() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuButton(
            icon: FontAwesomeIcons.key,
            title: 'Kata Sandi & Keamanan',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NIKKonfirmasiPage(),
                ),
              );
            },
          ),
          const Divider(height: 24, color: Color(0xFFE8F3F1)),
          _buildMenuButton(
            icon: FontAwesomeIcons.hospital,
            title: 'Rumah Sakit Terdekat',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HospitalPage(),
                ),
              );
            },
          ),
          const Divider(height: 24, color: Color(0xFFE8F3F1)),
          _buildMenuButton(
            icon: FontAwesomeIcons.phone,
            title: 'Nomor Gawat Darurat Nasional',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NomorGawatDarurat(),
                ),
              );
            },
          ),
          const Divider(height: 24, color: Color(0xFFE8F3F1)),
          _buildMenuButton(
            icon: FontAwesomeIcons.infoCircle,
            title: 'Tentang GlucoWise',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutGlucoWisePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3F1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 18,
                  color: const Color(0xFF199A8E),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF101623),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showLogoutConfirmation(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Color(0xFF199A8E), width: 1.5),
            ),
            icon: const Icon(
              FontAwesomeIcons.signOutAlt,
              size: 18,
              color: Color(0xFF199A8E),
            ),
            label: const Text(
              'Keluar',
              style: TextStyle(
                color: Color(0xFF199A8E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
