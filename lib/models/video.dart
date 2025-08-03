import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Video {
  String username;
  String uid;

  String videoId;
  List likes;
  int commentcount;
  int sharecount;
  String songname;
  String caption;
  String thumbnail;
  String profilepic;
  String videourl;

  Video({
    required this.username,
    required this.uid,
    required this.videoId,
    required this.likes,
    required this.commentcount,
    required this.caption,
    required this.profilepic,
    required this.sharecount,
    required this.songname,
    required this.thumbnail,
    required this.videourl,

  });

  Map<String, dynamic> tojson() => {
    "username": username,
    "uid": uid,
    "videoId": videoId,
    "likes": likes,
    "commentcount": commentcount,
    "sharecount": sharecount,
    "songname": songname,
    "caption": caption,
    "thumbnail": thumbnail,
    "profilepic": profilepic,
            "videourl": videourl,

  };

  static Video fromsnap(DocumentSnapshot docsnap) {
    var snapshot = docsnap.data() as Map<String, dynamic>;
    return Video(
      username: snapshot['username'],
      uid: snapshot['uid'],
      videoId: snapshot['videoId'],
      likes: snapshot['likes'],
      commentcount: snapshot['commentcount'],
      caption: snapshot['caption'],
      profilepic: snapshot['profilepic'],
      sharecount: snapshot['sharecount'],
      songname: snapshot['songname'],
      thumbnail: snapshot['thumbnail'],      
      videourl: snapshot['videourl'],

    );
  }
}
