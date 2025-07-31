import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tiktok_clonee/constants.dart';
import 'package:tiktok_clonee/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadvideoController extends GetxController {
  // Upload video with song name, caption and video path
  uploadvideo(String songName, String caption, String videopath) async {
    try {
      // Get current user ID
      String uid = firebaseauth.currentUser!.uid;
      // Get user document from Firestore
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(uid)
          .get();

      // Get total number of videos to generate new video ID
      var allDocs = await firestore.collection('videos').get();
      int length = allDocs.docs.length;
      // Upload video file to Firebase Storage and get URL
      String videourl = await _uploadvideoToStorage("video $length", videopath);
      // Upload thumbnail image and get URL
      String thumbnail = await _uploadImagetoStorage(
        "video $length",
        videopath,
      );
      // Create Video model object
      Video video = Video(
        username: (userDoc.data()! as Map<String, dynamic>)['name'],
        uid: uid,
        videoId: "video $length",
        likes: [],
        commentcount: 0,
        caption: caption,
        profilepic: (userDoc.data()! as Map<String, dynamic>)['profilepic'],
        sharecount: 0,
        songname: songName,
        thumbnail: thumbnail, videourl: videourl,
      );

      // Save video data to Firestore
      await firestore.collection('videos').doc('video $length').set(video.tojson());
      // Show success snackbar
      Get.snackbar("Video Uploaded Sucessfully", "Your video is sucesfully uploaded");
      print("video is sucessfully uploaded");
      // Go back to previous screen
      Get.back(); 
    } catch (e) {
      // Show error snackbar if upload fails
      Get.snackbar("error Uploading video", e.toString());
    }
  }

  // Compress video file to reduce size
  _compressvideo(String videopath) async {
    final compressvideo = await VideoCompress.compressVideo(
      videopath,
      quality: VideoQuality.MediumQuality,
    );

    return compressvideo!.file;
  }

  // Get thumbnail image from video file
  _getthumbnail(String videopath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videopath);
    return thumbnail;
  }

  // Upload compressed video file to Firebase Storage and return download URL
  Future<String> _uploadvideoToStorage(String id, String videopath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    UploadTask task = ref.putFile(await _compressvideo(videopath));
    TaskSnapshot snapshot = await task;
    String downloadurl = await snapshot.ref.getDownloadURL();
    return downloadurl;
  }

  // Upload thumbnail image to Firebase Storage and return download URL
  Future<String> _uploadImagetoStorage(String id, String videopath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(id);
    UploadTask task = ref.putFile((await _getthumbnail(videopath)));
    TaskSnapshot snapshot = await task;
    String downloadurl = await snapshot.ref.getDownloadURL();
    return downloadurl;
  }
}
