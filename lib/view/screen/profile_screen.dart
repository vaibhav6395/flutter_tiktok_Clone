import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:tiktok_clonee/Controller/profile_controller.dart';
import 'package:tiktok_clonee/constants.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileController profilecontroller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller and update user ID
    profilecontroller = Get.put(ProfileController());
    profilecontroller.updateuserId(widget.uid);
    print(" profile uid ${widget.uid}");
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        print("User data in build: ${controller.user}");
        if (controller.user.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black12,
            centerTitle: true,
            leading: const Icon(Icons.person_add_alt_1_outlined),
            actions: const [Icon(Icons.more_horiz)],
            title: Text(
              controller.user['name'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: controller.user['profilepic'],
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
              
                        children: [
                          Column(
                            children: [
                              Text(
                                controller.user['following'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Following',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
              
                          Container(
                            color: Colors.black54,
                            width: 1,
                            height: 15,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                          ),
                          Column(
                            children: [
                              Text(
                                controller.user['followers'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                             Text(
                                'Followers',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.black54,
                            width: 1,
                            height: 15,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                          ),
              
                          Column(
                            children: [
                              Text(
                                controller.user['likes'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text('Likes', style: const TextStyle(fontSize: 20)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: 140,
                        height: 47,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                        ),
                        child: InkWell(
                          onTap: () {
                            if (widget.uid == authcontroller.user.uid) {
                              authcontroller.signout();
                            } else {
                              controller.followuser();
                            }
                          },
                          child: Center(
                            child: Text(
                              widget.uid == authcontroller.user.uid
                                  ? 'Sign out'
                                  : controller.user['isfollowing']
                                  ? 'unfollow'
                                  : 'follow',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GridView.builder(physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1,crossAxisSpacing: 5),itemCount: controller.user['thumbnails'].length, itemBuilder: (context,index){
              String thumbnail=controller.user['thumbnails'][index];
             
              return InkWell(onTap: (){},  // here you can also make a function to navigate to the video page at particular video id through controller
                child: CachedNetworkImage(imageUrl: thumbnail,fit: BoxFit.cover,));
              
              
                      })
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
