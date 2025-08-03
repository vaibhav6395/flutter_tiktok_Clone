import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerItem extends StatefulWidget {
  final String videourl;
  const VideoPlayerItem({super.key, required this.videourl});

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController videoPlayerController;
@override
void initState() {
  super.initState();
  videoPlayerController=VideoPlayerController.networkUrl(Uri.parse(widget.videourl))..initialize().then((value){
    videoPlayerController.play();
    videoPlayerController.setVolume(1);

  });
}


  


  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
width: size.width,
height: size.height,
decoration: const BoxDecoration(
  color:  Colors.black
),
child: VideoPlayer(videoPlayerController),
    );
  }
}