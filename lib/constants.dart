import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clonee/Controller/auth_controller.dart';
import 'package:tiktok_clonee/view/screen/addvideoScreen.dart';
import 'package:tiktok_clonee/view/screen/profile_screen.dart';
import 'package:tiktok_clonee/view/screen/serach_screen.dart';
import 'package:tiktok_clonee/view/screen/videoScreen.dart';



List pages=[
  Videoscreen(),
   SerachScreen(),
  const Addvideoscreen(),
  Text("message  screen"),
  ProfileScreen(uid: authcontroller.user.uid),


];
const backgroundcolor=Colors.black;
var buttonColor=Colors.red[400];
const Bordercolor=Colors.grey;


var firebaseauth=FirebaseAuth.instance;
var firebaseStorage=FirebaseStorage.instance;
var   firestore   =FirebaseFirestore.instance;  

//controller
var authcontroller=AuthController.instance;