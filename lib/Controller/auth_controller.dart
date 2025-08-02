import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clonee/constants.dart';
import 'package:tiktok_clonee/models/usermodel.dart';
import 'package:tiktok_clonee/view/screen/auth/loginscreen.dart';
import 'package:tiktok_clonee/view/screen/homescreen.dart';

class AuthController extends GetxController{
  static AuthController instance =Get.find();

  // Reactive user object to track the current Firebase user
  late Rx<User?> _user;

  // Getter to access the current user value
  User get user => _user.value!;  

  @override
  void onReady() {
    super.onReady();
    // Initialize the reactive user with the current Firebase user
    _user=Rx<User?>(firebaseauth.currentUser);
    // Bind the user stream to listen for authentication state changes
    _user.bindStream(firebaseauth.authStateChanges());
    // Whenever the user changes, call _setinitialScreen to update UI
    ever(_user,_setinitialScreen);
  }

  // Set the initial screen based on user authentication status
  void _setinitialScreen(User? user){
    if(user==null){
      // If user is null, navigate to login screen
      Get.offAll(() => Loginscreen());
    }else{
      // If user is logged in, navigate to home screen
      Get.offAll(() => Homescreen());
    }
  }

  // Upload user profile image to Firebase Storage and return download URL
  Future<String> _uploadtoFirebasseStorage(File image) async {
    try {
      // Create a reference to the profile_pics folder with current user ID
      Reference ref = firebaseStorage.ref().child('profile_pics').child(firebaseauth.currentUser!.uid);
      // Start uploading the image file
      UploadTask uploadtask = ref.putFile(image);

      // Await the upload task completion
      TaskSnapshot snapshot = await uploadtask.whenComplete(() => null);

      // Check if upload was successful
      if (snapshot.state == TaskState.success) {
        // Get the download URL of the uploaded image
        String downloadurl = await snapshot.ref.getDownloadURL();
        print("Upload successful, download URL: $downloadurl");
        return downloadurl;
      } else {
        throw Exception("Image upload failed with state: ${snapshot.state}");
      }
    } catch (e) {
      print("Error uploading image: $e");
      rethrow;
    }
  }

  // Register a new user with email, password, username and profile image
  Future<void> registeruser(String Username,String email ,String password,File? image) async {
    try {
      // Check if all fields are filled and image is selected
      if(Username.isNotEmpty  && email.isNotEmpty && password.isNotEmpty && image!=null){
        // Create user with email and password
        UserCredential credential=  await  firebaseauth.createUserWithEmailAndPassword(email: email, password: password);
        // Upload profile image and get download URL
        String downloadurl=await _uploadtoFirebasseStorage(image);
        // Create user model with details
        Usermodel usermodel=Usermodel(name: Username, profile_pic: downloadurl, email: email, uid: credential.user!.uid);
        // Save user data to Firestore
        await  firestore.collection('users').doc(credential.user!.uid).set(usermodel.tojson());
      }else{
        // Show error if any field is empty
        Get.snackbar("Error", "Please Enter valid details ");
      }
    } catch (e) {
      // Show error if registration fails
      Get.snackbar("Error Creating account", e.toString());
    }
  }

  // Reactive variable to hold the picked profile image file
  late Rx<File?> _pickedimage;

  // Getter to access the picked profile picture file
  File? get Profilepic=>_pickedimage.value;

  // Pick an image from the gallery for profile picture
  void pickImage()async{
    // Use ImagePicker to select image from gallery
    final pickedImage=await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedImage!=null){
      // Show snackbar on successful image selection
      Get.snackbar("Profile picture", "Your profile picture is Selected");
    }else{
            Get.snackbar("Profile picture error", "please upload a profile picture");

    }
    // Update threactivee  picked image variable
    _pickedimage=Rx<File?>(File(pickedImage!.path));
  }

  // Login user with email and password
  void loginuser(String email,String Password)async{
    try {
      // Check if email and password are not empty
      if(email.isNotEmpty && Password.isNotEmpty){
        // Sign in with Firebase Authentication
        await firebaseauth.signInWithEmailAndPassword(email: email, password: Password);
        // Show success snackbar
        Get.snackbar("Logged In ", "sucessfully logged in ");
      }else{
        // Show error if fields are empty
        Get.snackbar("Error logging in", "Please enter all the fields ");
      }
    } catch (e) {
      // Show error if login fails
      Get.snackbar("Error in creating account", e.toString());
    }
  }

  // Sign out the current user
  void signout() async{
    await firebaseauth.signOut();
  }

}
