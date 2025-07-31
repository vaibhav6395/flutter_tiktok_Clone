import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clonee/Controller/comment_controller.dart';
import 'package:tiktok_clonee/constants.dart';
import 'package:timeago/timeago.dart' as tago;

class CommentScreen extends StatelessWidget {
  final String id;
  CommentScreen({super.key, required this.id});
  TextEditingController commenttextcontroller = TextEditingController();
  CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    commentController.updatepostid(id);

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: commentController.comments.length,
                  itemBuilder: (context, index) {
                    final comment = commentController.comments[index];

                    return Obx(() {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(comment.profilepic),
                        ),
                        title: Row(
                          children: [
                            Text(
                              "${comment.username}  ",
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              comment.comment,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              tago.format(comment.datePublished.toDate()),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${comment.likes.length} likes',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        trailing: InkWell(
                          onTap: () =>
                              commentController.likecomment(comment.id),

                          child: Icon(
                            Icons.favorite,
                            size: 25,
                            color:
                                comment.likes.contains(authcontroller.user.uid)
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
              const Divider(),
              ListTile(
                title: TextFormField(
                  controller: commenttextcontroller,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "comment",
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                trailing: TextButton(
                  onPressed: () =>
                      commentController.postcomment(commenttextcontroller.text),
                  child: const Text(
                    'Send',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
