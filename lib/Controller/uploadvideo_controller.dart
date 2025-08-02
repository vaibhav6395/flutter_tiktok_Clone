import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:tiktok_clonee/constants.dart';
import 'package:tiktok_clonee/models/video.dart';
import 'package:video_compress/video_compress.dart';

class UploadvideoController extends GetxController {
  
  uploadvideo(String songName, String caption, String videopath) async {
    try {
      // Get current user ID  and  user details from Firestore to pass in video
      String uid = firebaseauth.currentUser!.uid;
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(uid)
          .get();

      // Get total number of videos documents to generate new video ID
      var allDocs = await firestore.collection('videos').get();
      int length = allDocs.docs.length;

      // Upload video file to  Storage  videos => videoid =>video and return url
      String videourl = await _uploadvideoToStorage("video $length", videopath);

      // Upload thumbnail image to storage  Thumbnails folder => videoid=> img   and return URL
      String thumbnail = await _uploadImagetoStorage(
        "video $length",
        videopath,
      );

      // -----------------------Create Video model object and saves it to Firestore as video details details
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
        thumbnail: thumbnail,
        videourl: videourl,
      );

      // Save video data to Firestore   videos => videoID => video details
      await firestore
          .collection('videos')
          .doc('video $length')
          .set(video.tojson());
      Get.snackbar(
        "Video Uploaded Sucessfully",
        "Your video is sucesfully uploaded",
      );
      print("video is sucessfully uploaded");
      Get.back();
    } catch (e) {
      Get.snackbar("error Uploading video", e.toString());
    }
  }

  _compressvideo(String videopath) async {
    final compressvideo = await VideoCompress.compressVideo(
      videopath,
      quality: VideoQuality.MediumQuality,
    );

    return compressvideo!.file;
  }

  _getthumbnail(String videopath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videopath);
    return thumbnail;
  }

  Future<String> _uploadvideoToStorage(String videoid, String videopath) async {
    Reference ref = firebaseStorage.ref().child('videos').child(videoid);
    UploadTask task = ref.putFile(await _compressvideo(videopath));
    TaskSnapshot snapshot = await task;
    String downloadurl = await snapshot.ref.getDownloadURL();
    return downloadurl;
  }

  Future<String> _uploadImagetoStorage(String videoid, String videopath) async {
    Reference ref = firebaseStorage.ref().child('thumbnails').child(videoid);
    UploadTask task = ref.putFile((await _getthumbnail(videopath)));
    TaskSnapshot snapshot = await task;
    String downloadurl = await snapshot.ref.getDownloadURL();
    return downloadurl;
  }
}
