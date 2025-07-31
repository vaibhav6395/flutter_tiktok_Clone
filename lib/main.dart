import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clonee/Controller/auth_controller.dart';
import 'package:tiktok_clonee/constants.dart';
import 'package:tiktok_clonee/firebase_options.dart';
import 'package:tiktok_clonee/view/screen/auth/loginscreen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(    options: DefaultFirebaseOptions.currentPlatform,).then((onValue)=>{
Get.put(AuthController())
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,  
      title: 'tiktok Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundcolor,
      ),
      home: Loginscreen(),
    );
  }
}

