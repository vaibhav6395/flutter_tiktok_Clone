import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clonee/Controller/search_controller.dart';
import 'package:tiktok_clonee/models/usermodel.dart';
import 'package:tiktok_clonee/view/screen/profile_screen.dart';

class SerachScreen extends StatelessWidget {
  SerachScreen({super.key});

  final Searchcontroller controller = Searchcontroller();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: TextFormField(
              decoration: const InputDecoration(
                filled: false,
                hintText: "Search",
                hintStyle: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onFieldSubmitted: (value) => controller.searchUser(value),
            ),
          ),
          body: controller.searcheduser.isEmpty
              ? Center(
                  child: const Text(
                    "Search for user ",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: controller.searcheduser.length,
        
                  itemBuilder: (context, index){
                    Usermodel user = controller.searcheduser[index];
                    print(user.name);
                                        print(user.uid);
                                                            print(user.profile_pic);
                                                                                print(controller.searcheduser.length);

                   return InkWell(
                      onTap: () =>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen(uid: user.uid))),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.profile_pic),
                          backgroundColor: Colors.amber ,
                        ),
                        title: Text(user.name,style: const TextStyle(fontSize: 18,color: Colors.white),),
                      ),
                    );
                  },
                ),
        );
      }
    );
  }
}
