import 'package:flutter/material.dart';

enum EnumType{INTERNET,PROGRESS}

class CustomDialog{

  CustomDialog();

  Dialog dialog(EnumType type,double height,double width){
    return Dialog(
      elevation: 10,
      child: EnumType.INTERNET.index == type ? InternetDialog(height,width) : ProgressDialog(height,width),
    );
  }

  Widget InternetDialog(double height,double width){
    return Container(
      height: height / 4,
      width: width / 3,
    );
  }

  Widget ProgressDialog(double height,double width){
    return Container(
      height: height / 10,
      width: width / 10,
      child: Row(
        children: [
          SizedBox(width: width / 10,),
          CircularProgressIndicator(),
          SizedBox(width: width / 20,),
          Text('Loading...',style: TextStyle(fontWeight: FontWeight.w300,fontSize: width / 20),)
        ],
      ),
    );
  }

}