import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_card/image_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 30),
            UserIntro(),
            SizedBox(height: 10),
            SearchInput(),
            SizedBox(height: 10),
            CategoryIcons(),
            SizedBox(height: 10),
            CardGluco(),
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
      spacing: 10,
      runSpacing: 20,
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
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color(0xFFFFD0DC),
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFFFD0DC),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                widget.icon,
                color: const Color(0xFFC63755),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.text,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFC63755), width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(
              Icons.search,
              color: Color(0xFFC63755),
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
  int _currentIndex = 0;

  List<Map<String, dynamic>> edukasiItems = [
    {
      'image': 'https://www.tanotofoundation.org/wp-content/uploads/2022/01/WhatsApp-Image-2022-01-18-at-14.42.44-1-1024x768.jpeg',
      'title': 'Gizi Seimbang',
      'description': 'Pentingnya makanan sehat untuk penderita diabetes.'
    },
    {
      'image': 'https://p2ptm.kemkes.go.id/uploads//TmQwU05BQS9YYlJpanB5VnNtRldFUT09/30_Juni_04.png',
      'title': 'Aktivitas Fisik',
      'description': 'Olahraga yang baik untuk mengontrol kadar gula darah.'
    },
    {
      'image': 'https://mysiloam-api.siloamhospitals.com/public-asset/website-cms/website-cms-16855041440993113.webp',
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
          height: 250,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: edukasiItems.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = edukasiItems[index];
              return Padding(
                padding: const EdgeInsets.all(8.0), 
                child: TransparentImageCard(
                  width: double.infinity,
                  height: 200,
                  imageProvider: NetworkImage(item['image']),
                  title: Text(
                    item['title'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            edukasiItems.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 12 : 8,
              height: _currentIndex == index ? 12 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.redAccent : Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardGluco extends StatelessWidget {
  const CardGluco({super.key});

  @override
  Widget build(BuildContext context) {
    MainAxisAlignment.center;
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFC63755),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            FontAwesomeIcons.faceSmileBeam,
            color: Colors.white,
            size: 50,
          ),
        ),
        SizedBox(width: 10),
        Text('GlucoNote',
            style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}

class UserIntro extends StatelessWidget {
  const UserIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(
            'https://yt3.googleusercontent.com/6oxTgXwfJQivpKXxGTtyaNs26ShPf-6i84COg3Z3m1yQ2XBT--J8P07u5z2TkRmrfheMFIC1kA=s160-c-k-c0x00ffffff-no-rj',
          ),
        )
      ],
    );
  }
}
