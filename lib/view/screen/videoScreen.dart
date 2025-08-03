import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clonee/Controller/videocontroller.dart';
import 'package:tiktok_clonee/constants.dart';
import 'package:tiktok_clonee/view/screen/comment_screen.dart';
import 'package:tiktok_clonee/view/screen/video_player_item.dart';
import 'package:tiktok_clonee/view/widgets/cirecleanimation.dart';

class Videoscreen extends StatelessWidget {
  Videoscreen({super.key});

  final Videocontroller videocontroller = Get.put(Videocontroller());
  SizedBox builfprofile(String profilepic) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 5,
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(250),
                child: Image(
                  image: NetworkImage(profilepic),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox buildMusicsAlbum(String profilepic) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(11),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.grey, Colors.white],
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(25),
              child: Image(image: NetworkImage(profilepic), fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
    
      body:Obx(() {
        print(videocontroller.videolist.length);
        return PageView.builder(
          itemCount: videocontroller.videolist.length,
          controller: PageController(initialPage: 0, viewportFraction: 1),
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            final data = videocontroller.videolist[index];
            print(data.videoId); 


            print(videocontroller.videolist.length);
            Get.snackbar("video", data.profilepic);

            return Stack(
              children: [
                VideoPlayerItem(videourl: data.videourl),
                Column(
                  children: [
                    const SizedBox(height: 100),
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    data.username,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    data.caption,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.music_note,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "${data.songname} songname",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: 100,

                            margin: EdgeInsets.only(top: size.height / 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                builfprofile(data.profilepic),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () => videocontroller.likevide(
                                        data.videoId,
                                      ),
                                      child: Icon(
                                        Icons.favorite,
                                        size: 40,
                                        color:data.likes.contains(authcontroller.user.uid)?
                                    Colors.red
                                    :Colors.white
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      data.likes.length.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CommentScreen(videoid:data.videoId))),
                                      child: const Icon(
                                        Icons.comment,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      data.commentcount.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.reply,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      data.sharecount.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                CircleAnimation(
                                  child: buildMusicsAlbum(data.profilepic),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
