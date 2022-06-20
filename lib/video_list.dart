import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'color.dart';

/// Creates list of video players
class VideoList extends StatefulWidget {
  @override
  _VideoListState createState() => _VideoListState();
}

class _VideoListState extends State<VideoList> {
      String? youId = YoutubePlayer.convertUrlToId("https://www.youtube.com/watch?v=lTBPAjs2BtA");

  final List<YoutubePlayerController> _controllers = [
    'lTBPAjs2BtA',
    'G03UO8Zxhyo',
    '4lEm4pDL8ns',
    'ZEpxkTaOfaM',
    'qgLPM3QG4Is',
    'usqKg6Dsg2Q',
    'SBb3GIM2KI',
    'KRJUNQsJgLw',
    '1wHOZriHLq0',
  ]
      .map<YoutubePlayerController>(
        (videoId) => YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
          ),
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Primary,
        centerTitle: true,
        title: const Text('Video List Demo'),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return Row(
            children: [
              YoutubePlayer(

                key: ObjectKey(_controllers[index]),
                controller: _controllers[index],
                actionsPadding: const EdgeInsets.only(left: 16.0),
                bottomActions: [
                ],
              ),
              Spacer()
            ],
          );
        },
        itemCount: _controllers.length,
        separatorBuilder: (context, _) => const SizedBox(height: 10.0),
      ),
    );
  }
}