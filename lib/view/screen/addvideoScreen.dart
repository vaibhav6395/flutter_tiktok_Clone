import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clonee/constants.dart';
import 'package:tiktok_clonee/view/screen/auth/confirmScreen.dart';

class Addvideoscreen extends StatelessWidget {
  const Addvideoscreen({super.key});



pickvideo(ImageSource src,BuildContext context) async {
final video =await ImagePicker().pickVideo(source: src);
if(video!=null){
  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Confirmvideoscreen(videofile: File(video.path,), videopath: video.path,)));
}



}

  showoptionsDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text("Choose an option", style: TextStyle(fontSize: 25)),
        children: [
          SimpleDialogOption(
            onPressed: ()=>pickvideo(ImageSource.gallery,context),
            child: Row(
              children: const [
                Icon(Icons.image),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Gallary", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ), SimpleDialogOption(
            onPressed: ()=>pickvideo(ImageSource.camera,context),
            child: Row(
              children: const [
                Icon(Icons.camera_alt),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Camera", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ), SimpleDialogOption(
            onPressed: () =>Navigator.of(context).pop(),
            child: Row(
              children: const [
                Icon(Icons.cancel),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("cancel", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: () => showoptionsDialogBox(context),
          child: Container(
            height: 50,
            width: 190,
            decoration: BoxDecoration(color: buttonColor),
            child: const Center(
              child: Text(
                "Add video",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
