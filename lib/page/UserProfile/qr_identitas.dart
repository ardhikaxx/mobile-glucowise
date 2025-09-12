import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/services/auth_services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class DigitalIDScreen extends StatefulWidget {
  const DigitalIDScreen({super.key});

  @override
  State<DigitalIDScreen> createState() => _DigitalIDScreenState();
}

class _DigitalIDScreenState extends State<DigitalIDScreen> {
  late Future<UserData?> _userDataFuture;
  final GlobalKey _qrKey = GlobalKey();
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadProfileData();
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
      'timestamp': DateTime.now().toIso8601String(),
    };

    return userData.entries
        .where(
            (entry) => entry.value != null && entry.value.toString().isNotEmpty)
        .map((entry) => '${entry.key}:${entry.value}')
        .join('|');
  }

  Future<Uint8List?> _captureQrImage() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print("Error capturing QR image: $e");
      return null;
    }
  }

  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status.isDenied) {
        final result = await Permission.storage.request();
        return result.isGranted;
      }
      return status.isGranted;
    } else if (Platform.isIOS) {
      final status = await Permission.photos.status;
      if (status.isDenied) {
        final result = await Permission.photos.request();
        return result.isGranted;
      }
      return status.isGranted;
    }
    return false;
  }

  Future<void> _downloadQrCodeWithPhotoManager() async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        throw Exception(
            'Izin akses penyimpanan ditolak. Silakan berikan izin melalui pengaturan perangkat.');
      }

      final imageBytes = await _captureQrImage();
      if (imageBytes == null) {
        throw Exception('Gagal menghasilkan gambar QR code');
      }
      final tempDir = await getTemporaryDirectory();
      final userData = await _userDataFuture;
      final fileName =
          'glucoid_${userData?.namaLengkap.replaceAll(' ', '_') ?? 'user'}_${DateTime.now().millisecondsSinceEpoch}.png';
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(imageBytes);
      final AssetEntity? asset = await PhotoManager.editor.saveImage(
        imageBytes,
        title: fileName,
        filename: '',
      );
      if (tempFile.existsSync()) {
        tempFile.deleteSync();
      }

      if (asset != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('QR Code berhasil disimpan ke gallery'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        throw Exception('Gagal menyimpan ke gallery');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _downloadQrCode() async {
    await _downloadQrCodeWithPhotoManager();
  }

  Future<void> _shareQrCode(UserData user) async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      final imageBytes = await _captureQrImage();
      if (imageBytes == null) {
        throw Exception('Failed to generate QR code image');
      }

      final tempDir = await getTemporaryDirectory();
      final fileName =
          'glucoid_${user.namaLengkap.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);
      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'GlucoID - Identitas Digital ${user.namaLengkap}\n\nQR Code ini berisi informasi identitas untuk keperluan pelayanan medis.',
        subject: 'GlucoID - ${user.namaLengkap}',
      );

      // Clean up temporary file after a delay
      Future.delayed(const Duration(seconds: 30), () {
        if (file.existsSync()) {
          file.deleteSync();
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _shareToWhatsApp(UserData user) async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      final imageBytes = await _captureQrImage();
      if (imageBytes == null) {
        throw Exception('Failed to generate QR code image');
      }

      final tempDir = await getTemporaryDirectory();
      final fileName =
          'glucoid_${user.namaLengkap.replaceAll(' ', '_')}_whatsapp_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'GlucoID - Identitas Digital ${user.namaLengkap}\n\nQR Code ini berisi informasi identitas untuk keperluan pelayanan medis.',
        subject: 'GlucoID - ${user.namaLengkap}',
      );

      Future.delayed(const Duration(seconds: 30), () {
        if (file.existsSync()) {
          file.deleteSync();
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  void _showShareOptions(UserData user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header section
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),

                // Title
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16, left: 24, right: 24),
                  child: Row(
                    children: [
                      Text(
                        'Bagikan GlucoID',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),

                // Options list
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildOptionTile(
                        icon: Icons.qr_code_2,
                        iconColor: const Color(0xFF199A8E),
                        title: 'Download QR Code',
                        subtitle: 'Simpan QR code ke galeri',
                        onTap: () {
                          Navigator.pop(context);
                          _downloadQrCode();
                        },
                      ),
                      _buildOptionTile(
                        icon: Icons.share_rounded,
                        iconColor: const Color(0xFF199A8E),
                        title: 'Bagikan ke Media Sosial',
                        subtitle: 'Bagikan ke berbagai platform',
                        onTap: () {
                          Navigator.pop(context);
                          _shareQrCode(user);
                        },
                      ),
                      _buildOptionTile(
                        icon: FontAwesomeIcons.whatsapp,
                        iconColor: Colors.green,
                        title: 'Bagikan ke WhatsApp',
                        subtitle: 'Kirim langsung ke WhatsApp',
                        onTap: () {
                          Navigator.pop(context);
                          _shareToWhatsApp(user);
                        },
                      ),
                      _buildOptionTile(
                        icon: Icons.copy_all_rounded,
                        iconColor: const Color(0xFF199A8E),
                        title: 'Salin Data sebagai Teks',
                        subtitle: 'Salin ke clipboard',
                        onTap: () {
                          Navigator.pop(context);
                          _copyUserData(user);
                        },
                      ),
                    ],
                  ),
                ),

                // Cancel button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),

              const SizedBox(width: 16),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Chevron icon
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _copyUserData(UserData user) async {
    final userDataText = '''
NIK: ${user.nik}
Nama Lengkap: ${user.namaLengkap}
Email: ${user.email}
Tempat Lahir: ${user.tempatLahir ?? '-'}
Tanggal Lahir: ${user.tanggalLahir ?? '-'}
Jenis Kelamin: ${user.jenisKelamin ?? '-'}
Alamat: ${user.alamatLengkap ?? '-'}
Telepon: ${user.nomorTelepon ?? '-'}
Ibu Kandung: ${user.namaIbuKandung ?? '-'}
''';

    await Clipboard.setData(ClipboardData(text: userDataText));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data berhasil disalin ke clipboard'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        title: const Text(
          'GlucoID',
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
        actions: [
          FutureBuilder<UserData?>(
            future: _userDataFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData && !_isGenerating) {
                return IconButton(
                  icon: const Icon(FontAwesomeIcons.shareAlt,
                      color: Color(0xFF199A8E)),
                  onPressed: () => _showShareOptions(snapshot.data!),
                );
              }
              return const SizedBox();
            },
          ),
        ],
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
                      'Memuat GlucoID...',
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
                        'Gagal Memuat QR Code Identitas',
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
                    Container(
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
                            'Tunjukkan kepada tenaga medis untuk akses informasi kesehatan Anda',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              RepaintBoundary(
                                key: _qrKey,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
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
                                        dataModuleShape:
                                            QrDataModuleShape.circle,
                                        color: Color(0xFF199A8E),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    user.nik,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFF199A8E),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'QR code ini berisi informasi identitas Anda\nuntuk keperluan pelayanan medis',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8D8D8D),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: _isGenerating
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                                    )
                                  : const Icon(FontAwesomeIcons.shareAlt,
                                      size: 16),
                              label: _isGenerating
                                  ? const Text('Memproses...')
                                  : const Text('Bagikan QR Code'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF199A8E),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                              onPressed: _isGenerating
                                  ? null
                                  : () => _showShareOptions(user),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3F1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(FontAwesomeIcons.infoCircle,
                              color: Color(0xFF199A8E), size: 16),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'GlucoID ini dapat digunakan oleh tenaga medis untuk mengakses informasi kesehatan Anda yang diperlukan',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF199A8E),
                              ),
                            ),
                          ),
                        ],
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
