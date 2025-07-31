import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tiktok_clonee/constants.dart';
import 'package:tiktok_clonee/models/usermodel.dart';

class Searchcontroller extends GetxController {
  // Reactive list to hold searched users
  final Rx<List<Usermodel>> _searcheduser=Rx<List<Usermodel>>([]);
  // Getter to access searched users
  List<Usermodel> get searcheduser=> _searcheduser.value;

  // Search users by name starting with the typed string
  searchUser(String typpeduser)async{
    _searcheduser.bindStream(
      firestore.collection('users')
        .where('name',isGreaterThanOrEqualTo: typpeduser)
        .snapshots()
        .map((QuerySnapshot query){
          List<Usermodel> retval=[];
          for (var element in query.docs){
            retval.add(Usermodel.fromSnap(element));
          }
          return retval;
        })
    );
  }
}
