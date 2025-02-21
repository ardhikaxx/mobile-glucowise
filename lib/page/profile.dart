import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/auth/login.dart';
import 'package:medical_app/components/navbottom.dart';
import 'package:medical_app/page/edit_profile.dart';
import 'package:quickalert/quickalert.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  void _showLogoutConfirmation(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
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
            fontSize: 28,
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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NavBottom()),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 15),
            _buildInfoCard(),
            const SizedBox(height: 15),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
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
            backgroundImage: NetworkImage(
              'https://yt3.googleusercontent.com/6oxTgXwfJQivpKXxGTtyaNs26ShPf-6i84COg3Z3m1yQ2XBT--J8P07u5z2TkRmrfheMFIC1kA=s160-c-k-c0x00ffffff-no-rj',
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Yanuar Ardhika',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF199A8E),
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'ardhikayanuar58@gmail.com',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF101623),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: const Color(0xFFE8F3F1),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildInfoRow(Icons.phone, 'Nomor HP', '+628599648537'),
            const Divider(
              color: Color(0xFF199A8E),
            ),
            _buildInfoRow(Icons.location_on, 'Alamat', 'Bondowoso, Jawa Timur'),
            const Divider(
              color: Color(0xFF199A8E),
            ),
            _buildInfoRow(Icons.date_range, 'Bergabung Pada', '01 Jan 2024'),
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
          ),
        ),
        const SizedBox(height: 10),
        _buildButton(
          icon: FontAwesomeIcons.key,
          text: 'Edit Password',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
          ),
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
