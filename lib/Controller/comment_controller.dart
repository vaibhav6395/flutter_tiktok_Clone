import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:tiktok_clonee/constants.dart';
import 'package:tiktok_clonee/models/comment.dart';

class CommentController extends GetxController {
  // Reactive list to hold comments and their data 
  final Rx<List<Comment>> _comment = Rx<List<Comment>>([]);

  List<Comment> get comments => _comment.value;

  // variable stores the videoid to fetch comment details of that 
  String _videoid = "";

  // Update the video on scroll and fetch comments for that post or video
 void updatevideoid(String id) {
    _videoid = id;
    getcomment();
  }

  // Fetch comments from Firestore for the current post ID and bind to the reactive list
  // fetch data of  videos => videoid => details of comments of that video
  getcomment() async {
    _comment.bindStream(
      firestore
          .collection('videos')
          .doc(_videoid)
          .collection('comments')
          .snapshots()
          .map((QuerySnapshot query) {
            List<Comment> retval = [];
            for (var element in query.docs) {
              retval.add(Comment.Fromsnap(element));
            }
            return retval;
          }),
    );
  }

  // Post a new comment to Firestore under the current post ID
  postcomment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        // Get current user data from Firestore
        DocumentSnapshot snapshot = await firestore
            .collection('users')
            .doc(authcontroller.user.uid)
            .get();
        // Get all existing comments to determine new comment ID
        var alldocs = await firestore
            .collection('videos')
            .doc(_videoid)
            .collection('comments')
            .get();
        int len = alldocs.docs.length;

        // Create a new Comment object  and store it inside videos => videoid => comments doc
        Comment comment = Comment(
          username: (snapshot.data() as dynamic)['name'],
          comment: commentText.trim(),
          datePublished: DateTime.now(),
          likes: [],
          id: 'comment $len',
          uid: authcontroller.user.uid,
          profilepic: (snapshot.data() as dynamic)['profilepic'],
        );
        // Save the comment to Firestore
        await firestore
            .collection('videos')
            .doc(_videoid)
            .collection('comments')
            .doc('comment $len')
            .set(comment.tojson());
        // Update the comment count for the video
        DocumentSnapshot snap = await firestore
            .collection('videos')
            .doc(_videoid)
            .get();
        firestore.collection('videos').doc(_videoid).update({
          'commentcount': (snap.data()! as dynamic)['commentcount'] + 1,
        });
      }
    } catch (e) {
      // Show error snackbar if posting comment fails
      Get.snackbar("error while comment", e.toString());
    }
  }

  likecomment(String commentid)async{
    // get current user details and inside videos => videoid => comments => commentid doc checks the userid 
    var uid=authcontroller.user.uid;
    DocumentSnapshot doc=await firestore.collection('videos').doc(_videoid).collection('comments').doc(commentid).get();
    if((doc.data()! as dynamic)['likes'].contains(uid)){
      // If user already liked, remove like
      await  firestore.collection('videos').doc(_videoid).collection('comments').doc(commentid).update({
        'likes':FieldValue.arrayRemove([uid]),
      });
    }else{
      // If user has not liked, add like
      await firestore.collection('videos').doc(_videoid).collection('comments').doc(commentid).update({
        'likes':FieldValue.arrayUnion([uid]),
      });
    }
  }
}
