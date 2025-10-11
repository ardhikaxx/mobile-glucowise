import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/page/Chat/chat_select.dart';
import 'dart:async';
import 'package:medical_app/page/Edukasi/edukasi.dart';
import 'package:medical_app/model/user.dart';
import 'package:medical_app/page/UserProfile/edit_profile.dart';
import 'package:medical_app/page/Chatbot/chat_ai.dart';
import 'package:medical_app/services/auth_services.dart';
import 'package:medical_app/services/check_services.dart';

class DashboardScreen extends StatefulWidget {
  final UserData userData;

  const DashboardScreen({super.key, required this.userData});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> checkData = [];
  bool isLoading = true;
  Map<String, dynamic>? latestHealthData;
  Map<String, dynamic>? statusData;
  bool _mounted = false;
  late UserData _currentUserData;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _mounted = true;
    _currentUserData = widget.userData;
    _loadData();

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        if (_currentPage < 2) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void didUpdateWidget(DashboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userData != oldWidget.userData) {
      setState(() {
        _currentUserData = widget.userData;
      });
    }
  }

  @override
  void dispose() {
    _mounted = false;
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _loadData() async {
    if (!_mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final data = await CheckServices.getRiwayatKesehatan(context);

      if (!_mounted) return;

      if (data.isNotEmpty) {
        final latestData = data[0];
        final status =
            await CheckServices.getStatusRisiko(context, latestData["id_data"]);

        if (_mounted) {
          setState(() {
            checkData = data;
            latestHealthData = latestData;
            statusData = status;
            isLoading = false;
          });
        }
      } else if (_mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading data: $e");
      if (_mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  final List<String> _carouselImages = [
    'assets/img/image1.jpg',
    'assets/img/image2.jpg',
    'assets/img/image3.jpg',
  ];

  Widget _buildCarouselSlider() {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(bottom: 1),
      child: Stack(
        children: [
          // Carousel Items
          PageView.builder(
            controller: _pageController,
            itemCount: _carouselImages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    _carouselImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFE8F3F1),
                        child: const Center(
                          child: Icon(
                            Icons.image,
                            color: Color(0xFF199A8E),
                            size: 50,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_carouselImages.length, (index) {
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'GlucoWise',
          style: TextStyle(
            fontFamily: 'DarumadropOne',
            color: Color(0xFF199A8E),
            fontSize: 35,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              UserIntro(userData: _currentUserData),
              const SizedBox(height: 20),
              _buildCarouselSlider(),
              const SizedBox(height: 20),
              _buildGlucoziaAICard(context),
              const SizedBox(height: 12),
              _buildMenuSection(),
              const SizedBox(height: 12),
              isLoading
                  ? _buildLoadingCard()
                  : latestHealthData != null
                      ? CardGlucoInfo(
                          glucoseLevel:
                              latestHealthData!['gula_darah']?.toInt() ?? 0,
                          bloodPressure:
                              latestHealthData!['tensi_darah']?.toString() ??
                                  '0',
                          height:
                              latestHealthData!['tinggi_badan']?.toDouble() ??
                                  0,
                          weight:
                              latestHealthData!['berat_badan']?.toDouble() ?? 0,
                          status:
                              statusData?['kategori_risiko'] ?? 'Dalam proses',
                        )
                      : const CardNoData(),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Layanan Kesehatan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF138075),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildEdukasiMenuCard(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildKonsultasiDokterMenuCard(),
            ),
            //   Expanded(
            //     child: _buildGlucoziaAI(),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildEdukasiMenuCard() {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => EdukasiScreen(userData: _currentUserData),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 140,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF138075),
                Color(0xFF199A8E),
                Color(0xFF23B8A9),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF138075).withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: -10,
                right: -10,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.graduationCap,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Edukasi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'DarumadropOne',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pelajari diabetes',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Hover Effect
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Get.to(
                        () => EdukasiScreen(userData: _currentUserData),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                    splashColor: Colors.white.withOpacity(0.2),
                    highlightColor: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlucoziaAI() {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => const ChatBotPage(),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 140,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF34D399),
                Color(0xFF10B981),
                Color(0xFF059669),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF059669).withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Pattern
              Positioned(
                top: -10,
                right: -10,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Glucozia AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'DarumadropOne',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tanya Seputar Diabetes',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Hover Effect
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Get.to(
                        () => const ChatBotPage(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                    splashColor: Colors.white.withOpacity(0.2),
                    highlightColor: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKonsultasiDokterMenuCard() {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ChatSelectPage());
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 140,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF34D399),
                Color(0xFF10B981),
                Color(0xFF059669),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF059669).withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background Pattern
              Positioned(
                top: -10,
                right: -10,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        FontAwesomeIcons.userDoctor,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Konsultasi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'DarumadropOne',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Spesialis diabetes',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Hover Effect
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Get.to(() => const ChatSelectPage());
                    },
                    splashColor: Colors.white.withOpacity(0.2),
                    highlightColor: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F3F1),
              Color(0xFFD4E8E4),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF199A8E)),
                strokeWidth: 3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlucoziaAICard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => const ChatBotPage(),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF138075).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFE0F7FA)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF138075),
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Color(0xFFE0F7FA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        'Glucozia AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'DarumadropOne',
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tanya seputar tentang diabetes',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Kode untuk UserIntro, CardNoData, CardGlucoInfo tetap sama...
class UserIntro extends StatefulWidget {
  final UserData userData;
  const UserIntro({super.key, required this.userData});

  @override
  State<UserIntro> createState() => _UserIntroState();
}

class _UserIntroState extends State<UserIntro> {
  bool _isMounted = false;
  bool _isLoading = false;
  late UserData _currentUserData;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _currentUserData = widget.userData;
  }

  String _formatNIK(String nik) {
    if (nik.length != 16) return '**********';
    return '${nik.substring(0, 3)}**********${nik.substring(13)}';
  }

  Future<void> _refreshUserData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      UserData? updatedUserData = await AuthServices().getProfile();

      if (updatedUserData != null && _isMounted) {
        setState(() {
          _currentUserData = updatedUserData;
        });
      }
    } catch (e) {
      print('Error refreshing user data: $e');
    } finally {
      if (_isMounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Halo, ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey[700],
                        ),
                      ),
                      _isLoading
                          ? SizedBox(
                              width: 120,
                              height: 24,
                              child: const Center(
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF199A8E)),
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              _currentUserData.namaLengkap,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF199A8E),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatNIK(_currentUserData.nik),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () async {
                  if (_isLoading) return;

                  UserData? currentUserData = await AuthServices().getProfile();
                  if (currentUserData != null && _isMounted) {
                    bool? isUpdated = await Get.to(
                      () => EditProfileScreen(userData: currentUserData),
                      transition: Transition.rightToLeft,
                      duration: const Duration(milliseconds: 300),
                    );

                    if (isUpdated == true && _isMounted) {
                      await _refreshUserData();
                    }
                  }
                },
                child: Container(
                  width: 52,
                  height: 52,
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
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: _isLoading
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : const Center(
                          child: Icon(
                            FontAwesomeIcons.userPen,
                            size: 22,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CardNoData extends StatelessWidget {
  const CardNoData({
    super.key,
    this.message = "Belum ada data kesehatan terbaru anda",
    this.subMessage = "Silakan periksa kembali nanti",
  });

  final String message;
  final String subMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFF9FAFB),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3F1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3F1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
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
                  child: const Icon(
                    FontAwesomeIcons.circleExclamation,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF263238),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
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

class CardGlucoInfo extends StatelessWidget {
  final int glucoseLevel;
  final String bloodPressure;
  final double height;
  final double weight;
  final String? lastCheckDate;
  final bool isLoading;
  final String status;

  const CardGlucoInfo({
    super.key,
    required this.glucoseLevel,
    required this.bloodPressure,
    required this.height,
    required this.weight,
    this.lastCheckDate,
    this.isLoading = false,
    this.status = 'Dalam proses',
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = status == "Tinggi"
        ? Colors.red
        : status == "Sedang"
            ? Colors.orange
            : status == "Rendah"
                ? Colors.green
                : Colors.grey;

    final bmi = _calculateBMI(height, weight);
    final bmiStatus = _getBMIStatus(bmi);

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F3F1),
              Color(0xFFD4E8E4),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    _buildHeaderIcon(),
                    const SizedBox(width: 10),
                    const Text(
                      'Gluco Info',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF199A8E),
                      ),
                    ),
                  ]),
                  if (lastCheckDate != null)
                    _buildLastCheckedDate(lastCheckDate!),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          status == "Tinggi"
                              ? FontAwesomeIcons.triangleExclamation
                              : status == "Sedang"
                                  ? FontAwesomeIcons.circleExclamation
                                  : status == "Rendah"
                                      ? FontAwesomeIcons.circleCheck
                                      : FontAwesomeIcons.clock,
                          color: statusColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildGlucoseSection(statusColor, glucoseLevel),
              const SizedBox(height: 12),
              _buildVitalStatsSection(
                  bloodPressure, height, weight, bmi, bmiStatus),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF199A8E),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(
        FontAwesomeIcons.droplet,
        color: Colors.white,
        size: 22,
      ),
    );
  }

  Widget _buildLastCheckedDate(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "Updated: $date",
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF199A8E),
        ),
      ),
    );
  }

  Widget _buildGlucoseSection(Color statusColor, int glucoseLevel) {
    String status;
    String statusMessage;

    if (glucoseLevel < 70) {
      status = "Hipoglikemia";
      statusMessage = "Glukosa darah terlalu rendah";
    } else if (glucoseLevel >= 70 && glucoseLevel <= 130) {
      status = "Normal";
      statusMessage = "Glukosa darah dalam batas normal";
    } else if (glucoseLevel > 130 && glucoseLevel <= 180) {
      status = "Pra-Diabetes";
      statusMessage = "Glukosa darah sedikit tinggi";
    } else {
      status = "Diabetes";
      statusMessage = "Glukosa darah sangat tinggi";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monitor_heart, size: 18, color: Colors.black54),
              const SizedBox(width: 6),
              const Text(
                'Tingkat Glukosa Darah',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                glucoseLevel.toString(),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'mg/dL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            statusMessage,
            style: TextStyle(
              fontSize: 12,
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: _getGlucoseLevelValue(glucoseLevel),
            backgroundColor: Colors.grey[200],
            color: statusColor,
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "70",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                "130",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                "180",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                "200+",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _getGlucoseLevelValue(int glucoseLevel) {
    if (glucoseLevel <= 70) return 0.2;
    if (glucoseLevel <= 130) return 0.4;
    if (glucoseLevel <= 180) return 0.6;
    if (glucoseLevel <= 200) return 0.8;
    return 1.0;
  }

  Widget _buildVitalStatsSection(
    String bloodPressure,
    double height,
    double weight,
    double bmi,
    BMIStatus bmiStatus,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2,
      children: [
        _buildVitalStatItem(
          icon: FontAwesomeIcons.heartPulse,
          title: 'Tekanan Darah',
          value: '$bloodPressure mmHg',
          color: const Color(0xFF199A8E),
          gradient: [const Color(0xFF199A8E), const Color(0xFF23B8A9)],
        ),
        _buildVitalStatItem(
          icon: FontAwesomeIcons.rulerVertical,
          title: 'Tinggi Badan',
          value: '${height.toStringAsFixed(1)} cm',
          color: const Color(0xFF138075),
          gradient: [const Color(0xFF138075), const Color(0xFF23B8A9)],
        ),
        _buildVitalStatItem(
          icon: FontAwesomeIcons.weightScale,
          title: 'Berat Badan',
          value: '${weight.toStringAsFixed(1)} kg',
          color: const Color(0xFF199A8E),
          gradient: [const Color(0xFF199A8E), const Color(0xFF4FD1C5)],
        ),
        _buildVitalStatItem(
          icon: FontAwesomeIcons.calculator,
          title: 'IMT',
          value: bmi.toStringAsFixed(1),
          color: bmiStatus.color,
          gradient: [bmiStatus.color.withOpacity(0.8), bmiStatus.color],
        ),
      ],
    );
  }

  Widget _buildVitalStatItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required List<Color> gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 5),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateBMI(double height, double weight) {
    if (height <= 0) return 0;
    return weight / ((height / 100) * (height / 100));
  }

  BMIStatus _getBMIStatus(double bmi) {
    if (bmi < 18.5) return BMIStatus('Berat badan kurang', Colors.blue, 0.3);
    if (bmi < 25) return BMIStatus('Normal', Colors.green, 0.5);
    if (bmi < 30) return BMIStatus('Kelebihan berat badan', Colors.orange, 0.7);
    return BMIStatus('Obesitas', Colors.red, 1.0);
  }
}

class GlucoseStatus {
  final String label;
  final Color color;
  final double level;

  GlucoseStatus(this.label, this.color, this.level);
}

class BMIStatus {
  final String label;
  final Color color;
  final double level;

  BMIStatus(this.label, this.color, this.level);
}
