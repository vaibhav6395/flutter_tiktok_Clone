import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clonee/constants.dart';

class ProfileController extends GetxController {
  // Reactive map to hold user data
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  // Getter to access user data
  Map<String, dynamic> get user => _user.value;

  // Reactive string to hold user ID
  Rx<String> _uid = ''.obs;

  // Update the user ID and fetch user data
  updateuserId(String uid) {
    _uid.value = uid;
    getuserData();
  }

  // Fetch user data and related stats from Firestore
  getuserData() async {
    List<String> thumbnails = [];
    // Get videos uploaded by the user
    var myvideos = await firestore
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();

    // Collect thumbnails from user's videos
    for (var i = 0; i < myvideos.docs.length; i++) {
      thumbnails.add((myvideos.docs[i].data() as dynamic)['thumbnail']);
    }
    // Get user document from Firestore
    DocumentSnapshot userdoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .get();
    final userData = userdoc.data()! as dynamic;
    String name = userData['name'];
    String profilepic = userData['profilepic'];
    int likes = 0;
    int follower = 0;
    int following = 0;
    bool isfollowing = false;

    // Calculate total likes from user's videos
    for (var item in myvideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }
    // Get follower and following counts
    var followerdoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();
    var followingdoc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();

    follower = followerdoc.docs.length;
    following = followingdoc.docs.length;

    // Check if current user is following this profile
    firestore
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(authcontroller.user.uid)
        .get()
        .then(
          (value) => {
            if (value.exists) {isfollowing = true} else {isfollowing = false},
          },
        );

    // Update reactive user map with fetched data
    _user.value = {
      'followers': follower.toString(),
      'following': following.toString(),
      'isfollowing': isfollowing,
      "likes": likes.toString(),
      "profilepic": profilepic,
      'name': name,
      'thumbnails': thumbnails,
    };
    update();
  }

  // Follow or unfollow a user
  followuser() async {
    var doc = await firestore
        .collection('users')
        .doc(_uid.value)
        .collection('folloers  ')
        .doc(authcontroller.user.uid)
        .get();

    if (!doc.exists) {
      // If not following, add follower and following documents
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('folloers')
          .doc(authcontroller.user.uid)
          .set({});
      await firestore
          .collection('users')
          .doc(authcontroller.user.uid)
          .collection('folloers')
          .doc(_uid.value)
          .set({});
      // Update follower count locally
      _user.value.update("followers", (Value)=>(int.parse(Value)+1).toString());
    } else{
      // If already following, remove follower and following documents
      await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('folloers')
          .doc(authcontroller.user.uid)
          .delete() ;
      await firestore
          .collection('users')
          .doc(authcontroller.user.uid)
          .collection('folloers')
          .doc(_uid.value)
          .delete();
      // Update follower count locally
      _user.value.update("followers", (Value)=>(int.parse(Value)-1).toString());
    }
    // Toggle the isfollowing status locally
    _user.value.update("is following", (Value)=>! Value );
    update();
  }
}
