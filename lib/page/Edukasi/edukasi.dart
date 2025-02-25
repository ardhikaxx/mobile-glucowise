import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_card/image_card.dart';
import 'package:medical_app/data/data_edukasi.dart';
import 'package:medical_app/data/data_videoedukasi.dart';
import 'package:medical_app/page/Edukasi/detail_edukasi.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EdukasiScreen extends StatefulWidget {
  const EdukasiScreen({super.key});

  @override
  State<EdukasiScreen> createState() => _EdukasiScreenState();
}

class _EdukasiScreenState extends State<EdukasiScreen> {
  late List<Map<String, dynamic>> categories;
  String selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    categories = [
      {"name": "Semua", "icon": FontAwesomeIcons.bookBookmark},
      {"name": "Dasar Diabetes", "icon": FontAwesomeIcons.bookMedical},
      {"name": "Manajemen Diabetes", "icon": FontAwesomeIcons.kitMedical},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Edukasi Diabetes',
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
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //
          const SizedBox(height: 10),
          _buildCategoryFilter(),
          const SizedBox(height: 5),
          _buildSectionTitle("Video Edukasi"),
          _buildVideoList(),
          _buildSectionTitle("Diabetes Edukasi"),
          _buildEdukasiList(),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = categories[index]["name"] == selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ChoiceChip(
              showCheckmark: false,
              avatar: Icon(
                categories[index]["icon"],
                color: isSelected ? Colors.white : const Color(0XFF199A8E),
                size: 18,
              ),
              label: Text(categories[index]["name"]),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  selectedCategory = categories[index]["name"];
                });
              },
              selectedColor: const Color(0XFF199A8E),
              backgroundColor: const Color(0xFFE8F3F1),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0XFF199A8E),
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
              ),
              elevation: 1,
              shadowColor: Colors.black.withOpacity(0.5),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF199A8E),
        ),
      ),
    );
  }

  Widget _buildVideoList() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dataVideoEdukasi.length,
        itemBuilder: (context, index) {
          String? videoID =
              YoutubePlayer.convertUrlToId(dataVideoEdukasi[index]['url']!);
          if (videoID == null) return const SizedBox();
          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: InkWell(
              onTap: () {},
              child: TransparentImageCard(
                width: 320,
                height: 200,
                imageProvider: NetworkImage(YoutubePlayer.getThumbnail(
                  videoId: videoID,
                )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEdukasiList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: dataEdukasi.length,
        itemBuilder: (context, index) {
          final item = dataEdukasi[index];
          if (selectedCategory != 'Semua' &&
              item['category'] != selectedCategory) {
            return const SizedBox();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailEdukasiScreen(edukasi: item),
                  ),
                );
              },
              child: TransparentImageCard(
                width: double.infinity,
                imageProvider: NetworkImage(item['imageUrl']!),
                tags: [_tag(item['category']!)],
                title: _title(item['judul']!),
                description: _content(item['deskripsi']!),
              ),
            ),
          );
        },
      ),
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
