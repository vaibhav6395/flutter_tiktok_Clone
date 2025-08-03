import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String username;
  String comment;
  dynamic datePublished;
  List likes;
  String profilepic;
  String uid;
  String id;

  Comment({
    required this.username,
    required this.comment,
    required this.datePublished,
    required this.likes,
    required this.id,
    required this.uid,
    required this.profilepic,
  });

  Map<String, dynamic> tojson() => {
    "username": username,
    "comment": comment,
    "datePublished": datePublished,
    "likes": likes,
    "profilepic": profilepic,
    "uid": uid,
    "id": id,
  };

  static Comment Fromsnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      username: snapshot['username'],
      comment: snapshot['comment'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
      id: snapshot['id'],
      uid: snapshot['uid'],
      profilepic: snapshot['profilepic'],
    );
  }
}
