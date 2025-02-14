import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_card/image_card.dart';
import 'package:medical_app/page/edukasi.dart';
import 'package:medical_app/page/glucocheck.dart';
import 'package:medical_app/page/gluconote.dart';
import 'package:medical_app/page/glucoscreening.dart';
import 'package:medical_app/page/profile.dart';

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
            SizedBox(height: 20),
            SearchInput(),
            SizedBox(height: 20),
            CategoryIcons(),
            SizedBox(height: 20),
            Text(
              "Gluco Info",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
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
            SizedBox(height: 20),
            Text(
              "Edukasi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color(0xFF199A8E),
              ),
              textAlign: TextAlign.start,
            ),
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
      spacing: 24,
      runSpacing: 25,
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
  {'icon': FontAwesomeIcons.bookMedical, 'text': 'GlucoNote'},
  {'icon': FontAwesomeIcons.heartbeat, 'text': 'Screening'},
  {'icon': FontAwesomeIcons.kitMedical, 'text': 'GlucoCheck'},
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
      case 'GlucoNote':
        targetPage = const GlucoNoteScreen();
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
  // int _currentIndex = 0;

  List<Map<String, dynamic>> edukasiItems = [
    {
      'image':
          'https://www.tanotofoundation.org/wp-content/uploads/2022/01/WhatsApp-Image-2022-01-18-at-14.42.44-1-1024x768.jpeg',
      'title': 'Gizi Seimbang',
      'description': 'Pentingnya makanan sehat untuk penderita diabetes.'
    },
    {
      'image':
          'https://p2ptm.kemkes.go.id/uploads//TmQwU05BQS9YYlJpanB5VnNtRldFUT09/30_Juni_04.png',
      'title': 'Aktivitas Fisik',
      'description': 'Olahraga yang baik untuk mengontrol kadar gula darah.'
    },
    {
      'image':
          'https://mysiloam-api.siloamhospitals.com/public-asset/website-cms/website-cms-16855041440993113.webp',
      'title': 'Pemeriksaan Rutin',
      'description': 'Pentingnya cek kesehatan berkala bagi penderita diabetes.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 215,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: edukasiItems.length,
            // onPageChanged: (index) {
            //   setState(() {
            //     _currentIndex = index;
            //   });
            // },
            itemBuilder: (context, index) {
              final item = edukasiItems[index];
              return Padding(
                padding: const EdgeInsets.all(1),
                child: TransparentImageCard(
                  width: double.infinity,
                  height: 250,
                  imageProvider: NetworkImage(item['image']),
                  title: Text(
                    item['title'],
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  description: Text(
                    item['description'],
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 5),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: List.generate(
        //     edukasiItems.length,
        //     (index) => Container(
        //       margin: const EdgeInsets.symmetric(horizontal: 4),
        //       width: _currentIndex == index ? 12 : 8,
        //       height: _currentIndex == index ? 12 : 8,
        //       decoration: BoxDecoration(
        //         shape: BoxShape.circle,
        //         color: _currentIndex == index
        //             ? const Color(0xFF199A8E)
        //             : const Color(0xFFE8F3F1),
        //       ),
        //     ),
        //   ),
        // ),
      ],
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F3F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          const Icon(
            FontAwesomeIcons.heartbeat,
            color: Color(0xFF199A8E),
            size: 75,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "Gluco Info",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF199A8E),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "$glucoseLevel",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF101623),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "mg/dL",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF101623),
                      ),
                    ),
                  ]),
              Text(
                "BP: $bloodPressure mmHg",
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF101623),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(
                    "Height: ${height.toStringAsFixed(1)} cm",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF101623),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Weight: ${weight.toStringAsFixed(1)} kg",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF101623)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
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
