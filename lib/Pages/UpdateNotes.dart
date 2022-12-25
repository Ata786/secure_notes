import 'package:flutter/material.dart';
import '../Components/Colors.dart';
import '../Components/EditText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Routes/Routes.dart';

class UpdateNotes extends StatefulWidget {
  const UpdateNotes({Key? key}) : super(key: key);

  @override
  State<UpdateNotes> createState() => UpdateNotesData();
}

class UpdateNotesData extends State<UpdateNotes> {

  int i = 0;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String,dynamic>{}) as Map;

    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    TextEditingController titleController = TextEditingController();
    TextEditingController descController = TextEditingController();

    return Container(
      height: myHeight,
      width: myWidth,
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
            body:  SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: myHeight / 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Secure Notes',style: TextStyle(fontWeight: FontWeight.bold,fontSize: myHeight / 30,fontFamily: CustomColor.PRIMARY_BOLD_FONT),),
                      Row(
                        children: [
                          SizedBox(width: myWidth / 30,),
                          IconButton(color: Colors.black, onPressed: () {dataEdit();}, icon: Icon(Icons.edit),splashColor: Color(CustomColor.PRIMARY_COLOR),),
                          SizedBox(width: myWidth / 70,),
                          IconButton(color: Colors.black, onPressed: () {updateData(arguments['allData'].id,titleController.text,descController.text);}, icon: Icon(Icons.check),splashColor: Color(CustomColor.PRIMARY_COLOR)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: myHeight / 30,),
                  Padding(
                    padding: EdgeInsets.only(left: myWidth / 20),
                    child: EditText(
                      fieldEnable: i == 0 ? false : true,
                      controller: titleController..text = arguments['allData']['title'],
                      editWidth: myWidth / 1.4,
                      filledColor: Color(0xffd3d3d3),
                      filled: true,
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(myWidth / 50),
                      textStyle: TextStyle(fontFamily: CustomColor.PRIMARY_MEDIUM_FONT,fontSize: myWidth / 20,fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: myHeight / 30,),
                  Container(
                    height: myHeight / 300,
                    width: myWidth,
                    color: Color(0xffd3d3d3),
                  ),
                  SizedBox(height: myHeight / 70,),
                  Padding(
                    padding: EdgeInsets.only(left: myWidth / 20),
                    child: EditText(
                      fieldEnable: i ==0 ? false : true,
                      maxLines: 22,
                      controller: descController..text = arguments['allData']['Description'],
                      editWidth: myWidth / 1.1,
                      filledColor: Color(0xffd3d3d3),
                      filled: true,
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(myWidth / 50),
                      textStyle: TextStyle(fontFamily: CustomColor.PRIMARY_MEDIUM_FONT,fontSize: myWidth / 20,fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          )
      )
    );
  }

  void dataEdit() {
     setState(() {
       i = 1;
     });
  }

  void updateData(String id,String title,String desc) {
    firebaseFirestore.collection('UserNotes').doc(auth.currentUser!.uid).collection('Notes').doc(id).update({
      'title': title,
      'Description': desc
    }).then((value){
      try{
        Navigator.pushNamedAndRemoveUntil(context, Routers.NAVIGATION_VIEW, (route) => false);
      }catch(error){
        print('Updaton error ${error}');
      }
    });
  }

}



