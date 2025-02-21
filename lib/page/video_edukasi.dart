// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class VideoEdukasiScreen extends StatefulWidget {
//   const VideoEdukasiScreen({super.key, required this.videoId});

//   final String videoId;

//   @override
//   State<VideoEdukasiScreen> createState() => _VideoEdukasiScreenState();
// }

// class _VideoEdukasiScreenState extends State<VideoEdukasiScreen> {
//   late YoutubePlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: widget.videoId,
//       flags: const YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video Edukasi'),
//       ),
//       body: YoutubePlayerBuilder(
//         player: YoutubePlayer(controller: _controller),
//         builder: (context, player) {
//           return Column(
//             children: [
//               player,
//             ],
//           );
//         },
//       ),
//     );
//   }
// }