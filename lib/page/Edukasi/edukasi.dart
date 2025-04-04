import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_card/image_card.dart';
import 'package:medical_app/data/data_edukasi.dart';
import 'package:medical_app/data/data_videoedukasi.dart';
import 'package:medical_app/page/Edukasi/detail_edukasi.dart';
import 'package:medical_app/page/Edukasi/video_edukasi.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EdukasiScreen extends StatefulWidget {
  const EdukasiScreen({super.key});

  @override
  State<EdukasiScreen> createState() => _EdukasiScreenState();
}

class _EdukasiScreenState extends State<EdukasiScreen>
    with TickerProviderStateMixin {
  late List<Map<String, dynamic>> categories;
  String selectedCategory = 'Semua';

  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    categories = [
      {"name": "Semua", "icon": FontAwesomeIcons.bookBookmark},
      {"name": "Dasar Diabetes", "icon": FontAwesomeIcons.bookMedical},
      {"name": "Manajemen Diabetes", "icon": FontAwesomeIcons.kitMedical},
    ];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionBubble(
        items: <Bubble>[
          Bubble(
            title: "Chat Bot",
            iconColor: Colors.white,
            bubbleColor: const Color(0xFF199A8E),
            icon: FontAwesomeIcons.robot,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
            },
          ),
          Bubble(
            title: "Game Edukasi",
            iconColor: Colors.white,
            bubbleColor: const Color(0xFF199A8E),
            icon: FontAwesomeIcons.gamepad,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              _animationController.reverse();
            },
          ),
        ],
        animation: _animation,
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        iconColor: Colors.white,
        iconData: Icons.menu,
        backGroundColor: const Color(0xFF199A8E),
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
          _buildSectionTitle("Artikel Edukasi"),
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
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoEdukasiScreen(
                      videoUrl: dataVideoEdukasi[index]['url']!,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(12),
                child: Container(
                  width: 320,
                  height: 200,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        YoutubePlayer.getThumbnail(videoId: videoID),
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.play,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Tonton Sekarang',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
