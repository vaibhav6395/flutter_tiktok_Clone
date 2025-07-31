import 'package:flutter/material.dart';
import 'package:tiktok_clonee/constants.dart';
import 'package:tiktok_clonee/view/widgets/customIcons.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}


class _HomescreenState extends State<Homescreen> {
  int pageindex=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx){setState(() {
          pageindex=idx;  
        });},
        currentIndex: pageindex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed, items: [
        BottomNavigationBarItem(icon: Icon(Icons.home,size: 30,),  label:'Home'  ),
                BottomNavigationBarItem(icon: Icon(Icons.search,size: 30,),  label:'Search'  ),
                                BottomNavigationBarItem(icon: Customicons() , label:''  ),
                BottomNavigationBarItem(icon: Icon(Icons.message,size: 30,),  label:'message'  ),
                BottomNavigationBarItem(icon: Icon(Icons.person,size: 30,),  label:'Account'  ),


      ]),
      body: pages[pageindex],

    );
  }
}