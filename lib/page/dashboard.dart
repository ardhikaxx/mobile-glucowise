import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_card/image_card.dart';
import 'package:medical_app/page/Edukasi/detail_edukasi.dart';
import 'package:medical_app/page/Edukasi/edukasi.dart';
import 'package:medical_app/page/GlucoCheck/gluco_check.dart';
import 'package:medical_app/page/GlucoCare/gluco_care.dart';
import 'package:medical_app/page/Screening/gluco_screening.dart';
import 'package:medical_app/page/UserProfile/profile.dart';
import 'package:medical_app/data/data_edukasi.dart';
import 'dart:async';
import 'dart:math';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserIntro(),
            SizedBox(height: 15),
            SearchInput(),
            SizedBox(height: 15),
            CategoryIcons(),
            SizedBox(height: 15),
            Text(
              "Gluco Info",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF199A8E),
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            CardGlucoInfo(
              glucoseLevel: 75,
              bloodPressure: '120/80',
              height: 170,
              weight: 65,
            ),
            SizedBox(height: 15),
            Text(
              "Edukasi",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF199A8E),
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 10),
            CardEdukasiSwiper(),
          ],
        ),
      ),
    );
  }
}

class CategoryIcons extends StatelessWidget {
  const CategoryIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 25,
      runSpacing: 5,
      alignment: WrapAlignment.spaceEvenly,
      children: categories.map((category) {
        return CategoryIcon(
          icon: category['icon'] as IconData,
          text: category['text'] as String,
        );
      }).toList(),
    );
  }
}

List<Map<String, dynamic>> categories = [
  // ignore: deprecated_member_use
  {'icon': FontAwesomeIcons.heartbeat, 'text': 'Screening'},
  {'icon': FontAwesomeIcons.kitMedical, 'text': 'GlucoCheck'},
  {'icon': FontAwesomeIcons.pills, 'text': 'GlucoCare'},
  {'icon': FontAwesomeIcons.bookBookmark, 'text': 'Edukasi'},
];

class CategoryIcon extends StatefulWidget {
  final IconData icon;
  final String text;

  const CategoryIcon({
    required this.icon,
    required this.text,
    super.key,
  });

  @override
  State<CategoryIcon> createState() => _CategoryIconState();
}

class _CategoryIconState extends State<CategoryIcon> {
  void _navigateToPage(BuildContext context) {
    Widget targetPage;

    switch (widget.text) {
      case 'GlucoCare':
        targetPage = const GlucoCareScreen();
        break;
      case 'Screening':
        targetPage = const GlucoScreeningScreen();
        break;
      case 'GlucoCheck':
        targetPage = GlucoCheckScreen();
        break;
      case 'Edukasi':
        targetPage = const EdukasiScreen();
        break;
      default:
        targetPage = const DashboardScreen();
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color(0xFFE8F3F1),
      onTap: () => _navigateToPage(context),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3F1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                widget.icon,
                color: const Color(0xFF199A8E),
                size: 25,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.text,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(
              Icons.search,
              color: Color(0xFF199A8E),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardEdukasiSwiper extends StatefulWidget {
  const CardEdukasiSwiper({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CardEdukasiSwiperState createState() => _CardEdukasiSwiperState();
}

class _CardEdukasiSwiperState extends State<CardEdukasiSwiper> {
  final PageController _pageController = PageController();
  List<Map<String, String>> displayedData = [];
  Timer? _scrollTimer;
  Timer? _updateTimer;
  int _currentPage = 0;
  bool _isPageViewBuilt = false;

  @override
  void initState() {
    super.initState();
    _updateData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isPageViewBuilt = true;
      });
      _startAutoScroll();
    });
    _updateTimer = Timer.periodic(const Duration(minutes: 3), (timer) {
      _updateData();
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _updateTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _updateData() {
    setState(() {
      displayedData = _getRandomData();
      _currentPage = 0;
      if (_isPageViewBuilt) {
        _pageController.jumpToPage(0);
      }
    });
  }

  List<Map<String, String>> _getRandomData() {
    final random = Random();
    final shuffledData = List<Map<String, String>>.from(dataEdukasi)
      ..shuffle(random);
    return shuffledData.take(3).toList();
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_isPageViewBuilt || !_pageController.hasClients) return;

      _currentPage = (_currentPage + 1) % displayedData.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 280,
          width: double.infinity,
          child: _isPageViewBuilt
              ? PageView.builder(
                  controller: _pageController,
                  itemCount: displayedData.length,
                  itemBuilder: (context, index) {
                    final item = displayedData[index];

                    final String imageUrl =
                        item['imageUrl'] ?? 'https://via.placeholder.com/150';
                    final String title =
                        item['judul'] ?? 'Judul Tidak Tersedia';
                    final String subtitle = item['subJudul'] ?? 'Kategori';
                    final String description =
                        item['deskripsi'] ?? 'Deskripsi tidak tersedia.';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailEdukasiScreen(edukasi: item),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: TransparentImageCard(
                          width: double.infinity,
                          imageProvider: NetworkImage(imageUrl),
                          tags: [_tag(subtitle)],
                          title: _title(title),
                          description: _content(description),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child:
                      CircularProgressIndicator()), // Tambahkan indikator loading sebelum PageView siap
        ),
      ],
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF199A8E),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _content(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class CardGlucoInfo extends StatelessWidget {
  final int glucoseLevel;
  final String bloodPressure;
  final double height;
  final double weight;

  const CardGlucoInfo({
    super.key,
    required this.glucoseLevel,
    required this.bloodPressure,
    required this.height,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Tambahkan shadow agar lebih elegan
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFFE8F3F1),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFF199A8E),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                // ignore: deprecated_member_use
                FontAwesomeIcons.heartbeat,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "$glucoseLevel",
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF199A8E),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "mg/dL",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                Text(
                  "BP: $bloodPressure mmHg",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _infoText("Height", "${height.toStringAsFixed(1)} cm"),
                    const SizedBox(width: 10),
                    _infoText("Weight", "${weight.toStringAsFixed(1)} kg"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoText(String label, String value) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class UserIntro extends StatelessWidget {
  const UserIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi,',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text(
              'Yanuar Ardhika',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UserScreen()),
            );
          },
          child: const CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              'https://yt3.googleusercontent.com/6oxTgXwfJQivpKXxGTtyaNs26ShPf-6i84COg3Z3m1yQ2XBT--J8P07u5z2TkRmrfheMFIC1kA=s160-c-k-c0x00ffffff-no-rj',
            ),
          ),
        ),
      ],
    );
  }
}
