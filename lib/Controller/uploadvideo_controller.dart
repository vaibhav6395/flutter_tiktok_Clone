import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clonee/constants.dart';
import 'package:tiktok_clonee/models/video.dart';
import 'package:tiktok_clonee/view/screen/videoScreen.dart';
import 'package:video_compress/video_compress.dart';
import 'dart:io';

class UploadvideoController extends GetxController {
  
  uploadvideo(String songName, String caption, String videopath) async {
    try {
      // Check if user is logged in
      if (firebaseauth.currentUser == null) {
        Get.snackbar(
          "Error",
          "User not logged in",
        );
        return;
      }
      
      // Get current user ID and user details from Firestore to pass in video
      String uid = firebaseauth.currentUser!.uid;
      DocumentSnapshot userDoc = await firestore
          .collection('users')
          .doc(uid)
          .get();
      
      // Check if user document exists
      if (!userDoc.exists) {
        Get.snackbar(
          "Error",
          "User document not found",
        );
        return;
      }
      
      // Check if user document data exists
      if (userDoc.data() == null) {
        Get.snackbar(
          "Error",
          "User data is null",
        );
        return;
      }
      
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      
      // Check if required fields exist in user data
      if (!userData.containsKey('name') || userData['name'] == null) {
        Get.snackbar(
          "Error",
          "User name is missing",
        );
        return;
      }
      
      if (!userData.containsKey('profile_pic') || userData['profile_pic'] == null) {
        Get.snackbar(
          "Error",
          "User profile picture is missing",
        );
        return;
      }
      
      // Get total number of videos documents to generate new video ID
      var allDocs = await firestore.collection('videos').get();
      int length = allDocs.docs.length;
      print("the uid is $uid");
      print("the uid is ${userData['name']}");

      // Upload video file to Storage videos => videoid =>video and return url
      String videourl = await _uploadvideoToStorage("video $length", videopath);
      print("the error of videourl mis");

      // Upload thumbnail image to storage Thumbnails folder => videoid=> img and return URL
      String thumbnail = await _uploadImagetoStorage(
        "video $length",
        videopath,
      );

      // Create Video model object and saves it to Firestore as video details details
      Video video = Video(
        username: userData['name'],
        uid: uid,
        videoId: "video $length",
        likes: [],
        commentcount: 0,
        caption: caption,
        profilepic: userData['profile_pic'],
        sharecount: 0,
        songname: songName,
        thumbnail: thumbnail,
        videourl: videourl,
      );
      print("download url is ${userData['name']}");

      // Save video data to Firestore videos => videoID => video details
      await firestore
          .collection('videos')
          .doc('video $length')
          .set(video.tojson());
      Get.snackbar(
        "Video Uploaded Successfully",
        "Your video is successfully uploaded",
      );
      print("video is successfully uploaded");
Get.to(Videoscreen());    } catch (e) {
      Get.snackbar("Error Uploading video", e.toString());
    }
  }

  _compressvideo(String videopath) async {
    try {
      // Show progress indicator while compressing
      Get.snackbar("Compressing Video", "Please wait...");
      
      // Validate input
      if (videopath.isEmpty) {
        Get.snackbar("Video path Error", "Video path is empty");
        throw Exception("Video path is empty");
      }
      
      // Check if file exists
      File videoFile = File(videopath);
      if (!await videoFile.exists()) {
        Get.snackbar("Video Compression Error", "Video file does not exist at path: $videopath");
        throw Exception("Video file does not exist at path: $videopath");
      }
      
      // Check file size
      int fileSize = await videoFile.length();
      print("Video file size: $fileSize bytes");
      if (fileSize == 0) {
        Get.snackbar("Video Compression Error", "Video file is empty");
        throw Exception("Video file is empty");
      }
      
      // Log video path for debugging
      print("Attempting to compress video at path: $videopath");
      
      var compressvideo = await VideoCompress.compressVideo(
        videopath,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false, // Keep original file
      );

      // Check if compression was successful
      if (compressvideo == null) {
        Get.snackbar("Video Compression Error", "Failed to compress video. The compression process returned null. Check if the video format is supported.");
        throw Exception("Video compression failed - returned null. File path: $videopath, File size: $fileSize bytes");
      }

      // Check if compressed file exists
      if (compressvideo.file == null) {
        Get.snackbar("Video Compression Error", "Compressed file is null");
        throw Exception("Video compression failed - file is null");
      }

      // Check if file exists on filesystem
      if (!(await compressvideo.file!.exists())) {
        Get.snackbar("Video Compression Error", "Compressed file does not exist");
        throw Exception("Video compression failed - file does not exist");
      }
      return compressvideo.file;
    } catch (e) {
      Get.snackbar("Video Compression Error", "Error: ${e.toString()}");
      print("Video compression error details: ${e.toString()}");
      rethrow;
    }
  }

  _getthumbnail(String videopath) async {
    try {
      final thumbnail = await VideoCompress.getFileThumbnail(videopath);
      return thumbnail;
    } catch (e) {
      Get.snackbar("Thumbnail Error", "Failed to generate thumbnail: ${e.toString()}");
      rethrow;
    }
  }

  Future<String> _uploadvideoToStorage(String videoid, String videopath) async {
    print("download url is abcdr");

    Reference ref = firebaseStorage.ref().child('videos').child(videoid);
    UploadTask task = ref.putFile(await _compressvideo(videopath));
    TaskSnapshot snapshot = await task;
    String downloadurl = await snapshot.ref.getDownloadURL();
    print("download url is $downloadurl");
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
