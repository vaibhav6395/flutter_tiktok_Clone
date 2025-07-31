import 'package:cloud_firestore/cloud_firestore.dart';

class Usermodel {


  String name;
  String profile_pic;
  String  email;
  String uid;

  Usermodel({required this.name,required this.profile_pic,required this.email,required this.uid});

Map<String,dynamic>tojson()=>{
"name":name,
"profile_pic":profile_pic,
"email":email,
"uid":uid
};

static Usermodel fromSnap(DocumentSnapshot snap){
  var snapshot=snap.data() as Map<String,dynamic>;
  return Usermodel(name: snapshot['name'], profile_pic: snapshot['profile_pic'], email: snapshot['email'], uid: snapshot['uid']);


}



}