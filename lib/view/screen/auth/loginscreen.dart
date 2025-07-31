import 'package:flutter/material.dart';
import 'package:tiktok_clonee/constants.dart';
import 'package:tiktok_clonee/view/screen/auth/signupscreen.dart';
import 'package:tiktok_clonee/view/widgets/show_widgets/Text_input_field.dart';

class Loginscreen extends StatelessWidget {
  Loginscreen({super.key});
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
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
                "Login",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
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
                width: size.width-40,
                height: 50,
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: InkWell(
                  onTap: ()=>authcontroller.loginuser(_emailcontroller.text, _passwordcontroller.text),
                  child: const Center(
                    child: Text(
                      "Login",
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
                children: [const Text("Don't have an  account? ",style:TextStyle(fontSize: 20),),
                InkWell(onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Signupscreen()));
                },
                  child: Text("Register here  ",style:TextStyle(fontSize: 20,color:buttonColor),))],
              )
            ],
          ),
        ),
      ),
    );
  }
}
