import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clonee/constants.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  final Rx<String> _uid = ''.obs;

  // Update the user ID and fetch user data through that id
  void updateuserId(String uid) {
    _uid.value = uid;
    getuserData();
  }


  Future<void> getuserData() async {
    try {
      List<String> thumbnails = [];

      // Get videos uploaded by the user inside the whole collection wherever 'uid' value is defined of user id
      var myvideos = await firestore
          .collection('videos')
          .where('uid', isEqualTo: _uid.value)
          .get();

      // Collect thumbnails from list of  user's uploaded  videos and add into thumnail list
      for (var i = 0; i < myvideos.docs.length; i++) {
        thumbnails.add((myvideos.docs[i].data() as dynamic)['thumbnail']);
      }
      print("videoslist ${myvideos.docs.length}");

      // Get user document from Firestore
      DocumentSnapshot userdoc = await firestore
          .collection('users')
          .doc(_uid.value)
          .get();

      // Check if user document exists
      if (!userdoc.exists) {
        print("User document does not exist for UID: ${_uid.value}");
        return;
      }
   
      // here we do slf mapping 
      final userData = userdoc.data()! as dynamic;
      String name = userData['name'];
      String profilepic = userData['profile_pic'];
      int likes = 0;
      int follower = 0;
      int following = 0;
      bool isfollowing = false;

print("userdocument ${userData['name']}");
      // Calculate total likes from user's  uploaded  videos list
      for (var item in myvideos.docs) {
        var likesList = item.data()['likes'];
        if (likesList is List) {
          likes += likesList.length;
        }
      }
print("likes  ${likes}");

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

      // Check if current user is following this profile - properly awaited
      if (authcontroller.user.uid != null) {
        var isFollowingDoc = await firestore
            .collection('users')
            .doc(_uid.value)
            .collection('followers')
            .doc(authcontroller.user.uid)
            .get();

        isfollowing = isFollowingDoc.exists;
      }

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
      print("User data updated: ${_user.value}");
      update();
    } catch (e) {
      print("Error in getuserData: $e");
    }
  }

  // Follow or unfollow a user
  Future<void> followuser() async {
    try {
      var doc = await firestore
          .collection('users')
          .doc(_uid.value)
          .collection('followers')
          .doc(authcontroller.user.uid)
          .get();

      if (!doc.exists) {
        // If not following, add follower and following documents
        await firestore
            .collection('users')
            .doc(_uid.value)
            .collection('followers') // Fixed typo: was 'followrs'
            .doc(authcontroller.user.uid)
            .set({});
        await firestore
            .collection('users')
            .doc(authcontroller.user.uid)
            .collection('following')
            .doc(_uid.value)
            .set({});
        // Update follower count locally
        _user.value.update(
          "followers",
          (Value) => (int.parse(Value) + 1).toString(),
        );
      } else {
        // If already following, remove follower and following documents
        await firestore
            .collection('users')
            .doc(_uid.value)
            .collection('followers') // Fixed: was 'following' but should be 'followers'
            .doc(authcontroller.user.uid)
            .delete();
        await firestore
            .collection('users')
            .doc(authcontroller.user.uid)
            .collection('following')
            .doc(_uid.value)
            .delete();
        // Update follower count locally
        _user.value.update(
          "followers",
          (Value) => (int.parse(Value) - 1).toString(),
        );
      }
      // Toggle the isfollowing status locally
      _user.value.update("isfollowing", (Value) => !Value); // Fixed key name
      update();
    } catch (e) {
      print("Error in followuser: $e");
    }
  }
}
