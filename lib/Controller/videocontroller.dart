import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clonee/constants.dart';
import 'package:tiktok_clonee/models/video.dart';

class Videocontroller extends GetxController {
  // Reactive list to hold videos and their data
  final Rx<List<Video>> _videolist = Rx<List<Video>>([]);
  List<Video> get videolist => _videolist.value;

  @override
  void onInit() {
    super.onInit();
    // Bind Firestore videos collection snapshots to the reactive video list
    _videolist.bindStream(
      firestore.collection('videos').snapshots().map((QuerySnapshot query) {
        List<Video> retval = [];
        for (var element in query.docs) {
          retval.add(Video.fromsnap(element));
          print("element is ${element.exists}");
          print("username fetching ${retval[0].username}");
        }
        return retval;
      }),
    );
    print("video length is ${videolist.length}");
  }
  
// this is a simple form of snapshot.data() as dynamic ['']  by mapping it 
// instead we getting the data as a list of videomodel objects which is saved in a list searched user
// so this works as  searcheduser[i].videoid   here videoid is a field in videomodel class

// same logic for comment 
  // Like or unlike a video by updating the likes array in Firestore
  Future<void> likevide(String id) async {
    DocumentSnapshot snapshot=await firestore.collection('videos').doc(id).get();
    var uid=authcontroller.user.uid;

    if((snapshot.data()! as dynamic)['likes'].contains(uid)){
      // If user already liked, remove like
      await firestore.collection('videos').doc(id).update({
        'likes':FieldValue.arrayRemove([uid])
      });
    } else{
      // If user has not liked, add like
      await firestore.collection('videos').doc(id).update({
        'likes':FieldValue.arrayUnion([uid])
      });
    }
  }
}
