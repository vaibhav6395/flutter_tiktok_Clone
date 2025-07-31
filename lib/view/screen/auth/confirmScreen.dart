import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tiktok_clonee/Controller/uploadvideo_controller.dart';
import 'package:tiktok_clonee/view/widgets/show_widgets/Text_input_field.dart';
import 'package:video_player/video_player.dart';

class Confirmvideoscreen extends StatefulWidget {
  final File videofile;
  final String videopath;
  const Confirmvideoscreen({
    super.key,      
    required this.videofile,
    required this.videopath,
  });

  @override
  State<Confirmvideoscreen> createState() => _ConfirmvideoscreenState();
}

class _ConfirmvideoscreenState extends State<Confirmvideoscreen> {
  late VideoPlayerController controller;
  final TextEditingController _songcontroller=TextEditingController();
    final TextEditingController _captioncontroller=TextEditingController();
    final UploadvideoController videocontroller=UploadvideoController();



  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videofile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    controller.setLooping(true);
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: size.width,
              height: size.height / 1.5,
              child: VideoPlayer(controller),
            ),
            const SizedBox(height: 30),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: size.width - 40,
                    child: TextInputField(controller: _songcontroller, labelText: 'songname', icon: Icons.music_note),
                  ),
                const   SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: size.width - 40,
                    child: TextInputField(controller: _captioncontroller, labelText: 'Caption', icon: Icons.closed_caption),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed:()=>UploadvideoController().uploadvideo(_songcontroller.text, _captioncontroller.text, widget.videopath), child: Text("Share!",style: TextStyle(fontSize: 20,color: Colors.white),))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
