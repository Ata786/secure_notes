import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Routes/Routes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3),(){
      Navigator.pushNamedAndRemoveUntil(context, Routers.SIGNIN, (route) => false);
    //   if(auth.currentUser == null){
    //     Navigator.pushNamedAndRemoveUntil(context, Routers.SIGNIN, (route) => false);
    //   }else{
    //     Navigator.pushNamedAndRemoveUntil(context, Routers.NAVIGATION_VIEW, (route) => false);
    //   }
    });
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return setSplash(myHeight, myWidth);
  }

  Widget setSplash(double myHeight,double myWidth){
    return SafeArea(
        child:
    Container(
      height: myHeight,
      width: myWidth,
      padding: EdgeInsets.all(20),
      color: Colors.white,
      child: SvgPicture.asset('assets/notes_undraw.svg')
    )
    );
  }

}



