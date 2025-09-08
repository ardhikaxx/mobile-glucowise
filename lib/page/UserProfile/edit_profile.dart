import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/services/auth_services.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  final UserData userData;
  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _tempatLahirController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _namaIbuKandungController =
      TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _namaLengkapController.text = widget.userData.namaLengkap;
    _tempatLahirController.text = widget.userData.tempatLahir ?? "";
    _phoneController.text = widget.userData.nomorTelepon ?? "";
    _alamatController.text = widget.userData.alamatLengkap ?? "";
    _namaIbuKandungController.text = widget.userData.namaIbuKandung ?? "";
    _tanggalLahirController.text = widget.userData.tanggalLahir ?? "";
    _selectedGender = widget.userData.jenisKelamin;
  }

  /// Fungsi dialog konfirmasi keluar
  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin ingin kembali?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // batal
            child: const Text("Tidak", style: TextStyle(color: Color(0xFF199A8E))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // tutup dialog
              Navigator.pop(context); // kembali ke halaman sebelumnya
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF199A8E),
            ),
            child: const Text("Ya", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Fungsi update profile
  void updateProfile() async {
    Map<String, dynamic> profileData = {
      'nama_lengkap': _namaLengkapController.text,
      'tempat_lahir': _tempatLahirController.text,
      'tanggal_lahir': _tanggalLahirController.text,
      'jenis_kelamin': _selectedGender,
      'alamat_lengkap': _alamatController.text,
      'nomor_telepon': _phoneController.text,
      'nama_ibu_kandung': _namaIbuKandungController.text,
    };

    bool success = await AuthServices.editProfile(context, profileData);

    if (success) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      _showMessageDialog(
        title: "Berhasil",
        message: "Profil berhasil diperbarui.",
        isSuccess: true,
      );
    } else {
      _showMessageDialog(
        title: "Gagal",
        message: "Gagal memperbarui profil.",
        isSuccess: false,
      );
    }
  }

  void _showMessageDialog({
    required String title,
    required String message,
    bool isSuccess = true,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            color: isSuccess ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF199A8E),
            ),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// Fungsi pilih tanggal
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF199A8E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _tanggalLahirController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
            fontWeight: FontWeight.w900,
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
              onPressed: _showExitConfirmation,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildTextField(
                  "Nama Lengkap", Icons.person, _namaLengkapController),
              _buildTextField(
                  "Tempat Lahir", Icons.location_on, _tempatLahirController),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: _tanggalLahirController,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    labelText: "Tanggal Lahir",
                    labelStyle: const TextStyle(color: Color(0xFF199A8E)),
                    prefixIcon: const Icon(Icons.calendar_today,
                        color: Color(0xFF199A8E)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB), width: 1.5),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.date_range,
                          color: Color(0xFF199A8E)),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF9FAFB),
                    labelText: "Jenis Kelamin",
                    labelStyle: const TextStyle(color: Color(0xFF199A8E)),
                    prefixIcon: const Icon(Icons.person_outline,
                        color: Color(0xFF199A8E)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFFE5E7EB), width: 1.5),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: "Laki-laki", child: Text("Laki-laki")),
                    DropdownMenuItem(
                        value: "Perempuan", child: Text("Perempuan")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),
              ),
              _buildTextField("Alamat Lengkap", Icons.home, _alamatController),
              _buildTextField("Nomor Telepon", Icons.phone, _phoneController),
              _buildTextField(
                  "Nama Ibu Kandung", Icons.person, _namaIbuKandungController),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color(0xFF199A8E),
                  ),
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF199A8E)),
          prefixIcon: Icon(icon, color: const Color(0xFF199A8E)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
          ),
        ),
      ),
    );
  }
}
