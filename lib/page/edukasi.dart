import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_card/image_card.dart';
import 'package:medical_app/data/data_edukasi.dart';
import 'package:medical_app/data/data_videoedukasi.dart';
import 'package:medical_app/page/detail_edukasi.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class EdukasiScreen extends StatelessWidget {
  const EdukasiScreen({super.key});

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
            fontSize: 30,
            fontWeight: FontWeight.bold,
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
              onPressed: () {
                Navigator.pop(context);
              },
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
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Video Edukasi",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF199A8E),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dataVideoEdukasi.length,
              itemBuilder: (context, index) {
                String? videoID = YoutubePlayer.convertUrlToId(dataVideoEdukasi[index]['url']!);

                if (videoID == null) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: InkWell (
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
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Diabetes Edukasi",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF199A8E),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: dataEdukasi.length,
              itemBuilder: (context, index) {
                final item = dataEdukasi[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailEdukasiScreen(edukasi: item),
                        ),
                      );
                    },
                    child: TransparentImageCard(
                      width: double.infinity,
                      imageProvider: NetworkImage(item['imageUrl']!),
                      tags: [_tag(item['subJudul']!)],
                      title: _title(item['judul']!),
                      description: _content(item['deskripsi']!),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
