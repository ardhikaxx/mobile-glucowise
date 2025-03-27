import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medical_app/components/navbottom.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/page/UserProfile/edit_profile.dart';
import 'package:medical_app/services/auth_services.dart';
import 'package:quickalert/quickalert.dart';

class UserScreen extends StatefulWidget {
  final UserData userData;
  const UserScreen({super.key, required this.userData});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<UserData?> userData;
  bool _hasCheckedData = false;
  bool _isMounted = false; // Tambahkan flag untuk mengecek mounted state

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

      if (_isMounted && !_hasCheckedData && data != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isMounted && isUserDataIncomplete(data)) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.info,
              title: 'Data Tidak Lengkap',
              text:
                  'Data anda tidak lengkap, mohon lengkapi data dengan klik tombol edit.',
              confirmBtnText: 'OK',
              confirmBtnColor: const Color(0xFF199A8E),
            );
          }
          if (_isMounted) {
            setState(() {
              _hasCheckedData = true;
            });
          }
        });
      }
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
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: 'Konfirmasi Logout',
      text: 'Apakah Anda yakin ingin keluar?',
      confirmBtnText: 'Ya, Logout',
      cancelBtnText: 'Batal',
      confirmBtnColor: Colors.red,
      onConfirmBtnTap: () {
        Navigator.pop(context);
        _logout(context);
      },
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
      body: FutureBuilder<UserData?>(
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
    );
  }

  Widget _buildProfile(UserData user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildProfileHeader(user),
          const SizedBox(height: 15),
          _buildInfoCard(user),
          const SizedBox(height: 15),
          _buildActionButtons(context),
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
            border: Border.all(color: const Color(0xFF199A8E), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 55,
            backgroundColor: Color(0xFFE8F3F1),
            child: Icon(
              FontAwesomeIcons.userAlt,
              color: Color(0xFF199A8E),
              size: 50,
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
    return Card(
      color: const Color(0xFFE8F3F1),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildInfoRow(Icons.email_rounded, 'Email',
                user.email.isEmpty ? "Tidak ada data" : user.email),
            const Divider(color: Color(0xFF199A8E)),
            _buildInfoRow(
                Icons.phone, 'Nomor HP', user.nomorTelepon ?? "Tidak ada data"),
            const Divider(color: Color(0xFF199A8E)),
            _buildInfoRow(Icons.location_on, 'Alamat',
                user.alamatLengkap ?? "Tidak ada data"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF199A8E), size: 28),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF199A8E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF101623),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
                  _hasCheckedData = false;
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
