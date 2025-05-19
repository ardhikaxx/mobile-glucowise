import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medical_app/components/navbottom.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/page/UserProfile/edit_profile.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
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
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                Get.offAll(() => NavBottom(userData: widget.userData));
              },
            ),
          ),
        ),
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
              return const Center(child: Text("Gagal memuat profil"));
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileHeader(user),
          const SizedBox(height: 15),
          if (!isComplete) ...[
            _buildIncompleteDataCard(),
            const SizedBox(height: 15),
          ],
          if (isComplete) ...[
            _buildInfoCard(user),
            const SizedBox(height: 15),
          ],
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildIncompleteDataCard() {
    return Container(
      width: double.infinity,
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
              FontAwesomeIcons.exclamationTriangle,
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Data Tidak Lengkap',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF199A8E),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mohon lengkapi data profil Anda untuk pengalaman yang lebih baik',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
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
                'Lengkapi Data',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(UserData userData) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFE8F3F1),
                Color(0xFFD4ECE8),
              ],
            ),
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFA0E7DE),
                        Color(0xFF199A8E),
                      ],
                    ),
                  ),
                ),
                // Icon with shine effect
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.white70,
                      ],
                    ).createShader(bounds);
                  },
                  child: const Icon(
                    FontAwesomeIcons.userAlt,
                    color: Colors.white,
                    size: 55,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          userData.namaLengkap.isEmpty
              ? "Tidak ada data"
              : userData.namaLengkap,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF199A8E),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          userData.nik.isEmpty ? "Tidak ada data" : userData.nik,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF101623),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(UserData user) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE8F3F1),
            Color(0xFFF0F9F7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Email Section
            _buildEnhancedInfoItem(
              icon: FontAwesomeIcons.solidEnvelope,
              title: "Email",
              value: user.email.isEmpty ? "Tidak ada data" : user.email,
              iconColor: const Color(0xFF199A8E),
              iconBackground: const Color(0xFFD4ECE8),
            ),
            const SizedBox(height: 12),
            // Divider with decoration
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFF199A8E).withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Phone Section
            _buildEnhancedInfoItem(
              icon: FontAwesomeIcons.phoneAlt,
              title: "Nomor HP",
              value: user.nomorTelepon ?? "Tidak ada data",
              iconColor: const Color(0xFF199A8E),
              iconBackground: const Color(0xFFD4ECE8),
            ),
            const SizedBox(height: 12),
            // Divider with decoration
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFF199A8E).withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Address Section
            _buildEnhancedInfoItem(
              icon: FontAwesomeIcons.mapMarkerAlt,
              title: "Alamat",
              value: user.alamatLengkap ?? "Tidak ada data",
              iconColor: const Color(0xFF199A8E),
              iconBackground: const Color(0xFFD4ECE8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required Color iconBackground,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon with background
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              size: 18,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Text content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF57636C),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
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

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildButton(
          icon: FontAwesomeIcons.penToSquare,
          text: 'Edit Profil',
          onTap: () async {
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
        ),
        const SizedBox(height: 10),
        _buildLogoutButton(context),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: const Color(0xFF199A8E),
          foregroundColor: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showLogoutConfirmation(context),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: const BorderSide(color: Color(0xFF199A8E), width: 2),
        ),
        child: const Text(
          'Logout',
          style:
              TextStyle(color: Color(0xFF199A8E), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
