import 'package:flutter/material.dart';
import 'package:tiktok_clonee/constants.dart';
import 'package:tiktok_clonee/view/screen/auth/loginscreen.dart';
import 'package:tiktok_clonee/view/widgets/show_widgets/Text_input_field.dart';

class Signupscreen extends StatelessWidget {
  Signupscreen({super.key});
  final TextEditingController _emailcontroller    = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height-(MediaQuery.of(context).padding.top+kToolbarHeight)),
            child: IntrinsicHeight(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Tiktok clone",
                      style: TextStyle(
                        fontSize: 35,
                        color: buttonColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      "Register ",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 25),
                   Stack(
                     children: [
                       const  CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVVzFIs00C1WVmivQSlqsGgRu2ouRc4slMmQ&s",
                          ),
                          backgroundColor: Colors.black,
                        ),
                          Positioned(
                           bottom:- 10,
                          left:70,
                          right: 10,
                          child: IconButton(
                            onPressed: ()=>authcontroller.pickImage(),
                            icon:  Icon(Icons.add_a_photo),
                          ),
                        ),
                     ],
                   ),
                      
                    const SizedBox(height: 30),
                    Container(
                      width: size.width,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TextInputField(
                        controller: _usernamecontroller,
                        labelText: 'username',
                        icon: Icons.person,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: size.width,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                  
                      child: TextInputField(
                        controller: _emailcontroller,
                        labelText: 'Email',
                        icon: Icons.email,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: size.width,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                  
                      child: TextInputField(
                        controller: _passwordcontroller,
                        labelText: 'Paasword',
                        icon: Icons.lock,
                        isobscure: true,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: InkWell(
                        onTap: () {
                        authcontroller.registeruser(_usernamecontroller.text, _emailcontroller.text, _passwordcontroller.text, authcontroller.Profilepic);
                        },
                        child: const Center(
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(fontSize: 20),
                        ),
                        InkWell(
                          onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Loginscreen()));
                          },
                          child: Text(
                            "Login ",
                            style: TextStyle(fontSize: 20, color: buttonColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    
  }
 
}
