import 'package:avatar_glow/avatar_glow.dart';
import 'package:uuid/uuid.dart';
import '../Components/CheckInternet.dart';
import 'package:flutter/material.dart';
import '../Components/EditText.dart';
import '../Components/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Components/InternetDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../Routes/Routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:speech_to_text/speech_to_text.dart';


class CreateNotes extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateNotesPage();
  }

}

class CreateNotesPage extends State<CreateNotes> {

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();

  SpeechToText? speech ;
  bool speechEnable = false;

  List<String> menuItems = ['Posts','Notes'];
  String date = DateFormat('yyyy-MM-dd - kk:mm').format(DateTime.now());
  String itemValue = 'Notes';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    speech = SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(child: Scaffold(
      bottomSheet: button(context,myHeight, myWidth),
      body: Container(
        height: myHeight,
        width: myWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: myHeight / 12,
                width: myWidth,
                decoration: BoxDecoration(
                    color: Color(0xff000000).withOpacity(0.3)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                        child: Container(
                            margin:EdgeInsets.only(left: myWidth / 15),
                            child: Icon(Icons.arrow_back,color: Colors.white,))),
                  ],
                ),
              ),
              SizedBox(height: myHeight / 20,),
              Row(
                children: [
                  Image.asset('assets/notes.png',height: myHeight / 20,width: myWidth / 5,),
                  EditText(
                    fieldEnable: true,
                    controller: titleController,
                    editWidth: myWidth / 1.4,
                    filledColor: Color(0xffd3d3d3),
                    filled: true,
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(myWidth / 50),
                    hintText: 'Enter Title',
                    maxLength: 20,
                  )
                ],
              ),
              SizedBox(height: myHeight / 70,),
              Container(
                height: myHeight / 20,
                width: myWidth / 1.3,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Color(CustomColor.PRIMARY_COLOR),width: 2),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: itemValue,
                    items: menuItems.map(dropDownItem).toList(),
                    onChanged: (value) {
                      setState(() {
                        itemValue =  value!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: myHeight / 70,),
              Container(
                height: myHeight / 300,
                width: myWidth,
                color: Color(0xffd3d3d3),
              ),
              SizedBox(height: myHeight / 70,),
              EditText(
                fieldEnable: true,
                controller: desController,
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide.none,
                hintText: 'Type Something...',
                hintStyle: TextStyle(fontSize: myHeight / 35,fontWeight: FontWeight.bold),
                maxLines: 10,
                maxLength: 500,
              ),
            ],
          )
        ),
      ),
    ));
  }

  DropdownMenuItem<String> dropDownItem(String item){
    return DropdownMenuItem(
      value: item,
        child: Text(item)
    );
  }

  Widget button(BuildContext context,double myHeight,double myWidth){
    return Row(
      children: [
        Container(
          height: myHeight / 15,
          width: myWidth/1.3,
          margin: EdgeInsets.only(bottom: myHeight / 30,left: myWidth / 30),
          child: ElevatedButton(
              onPressed: ()async{
               bool conn = await CheckConnection.checkInternet(context);
                  if(conn == true){
                    addData(myHeight,myWidth);
                  }else{
                    showDialog(context: context, builder: (context){
                      return CustomDialog().dialog(EnumType.INTERNET, myHeight, myWidth);
                    });
                  }

              },
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                backgroundColor: Color(CustomColor.PRIMARY_COLOR),
              ),
              child: Center(child: Text('Save'),)
          ),
        ),
        Container(
          height: 65,
          width: 65,
          margin: EdgeInsets.only(bottom: myHeight / 30,left: myWidth / 70),
          child: AvatarGlow(
            animate: speechEnable,
            endRadius: 60,
            glowColor: Color(0xffff0000),
            duration: Duration(milliseconds: 2000),
            repeatPauseDuration: Duration(milliseconds: 100),
            repeat: true,
            child: InkWell(
              onTap: () => onListen(),
              child: Card(
              color: Color(0xffff0000),
                shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(myWidth/2))
    ),
                child: Center(child: speechEnable ? Icon(Icons.settings_voice,color: Colors.white,) : Icon(Icons.mic_none,color: Colors.white,),),
              ),
            ),
          ),
        )
      ],
    );
  }

  void addData(double myHeight,double myWidth)async{

    String id = auth.currentUser!.uid;
    bool checkNet = await CheckConnection.checkInternet(context);
    if(checkNet){
      if(titleController.text == '' || desController.text == ''){
       Fluttertoast.showToast(msg: 'Give Title and Description both');
      }else{
        if(itemValue == 'Notes'){
          String uid = Uuid().v1();
          firebaseFirestore.collection('UserNotes').doc(id).collection('Notes').doc(uid).set({
            'title': titleController.text,
            "Description": desController.text,
            'Data': date
          });
          Navigator.pushNamedAndRemoveUntil(context, Routers.NAVIGATION_VIEW, (route) => false,arguments: {'value':itemValue});
        }else{
          DocumentSnapshot documentSnapshot = await firebaseFirestore.collection('User').doc(id).get();
          firebaseFirestore.collection('UserPosts').doc(id).set({
            'title': titleController.text,
            "Description": desController.text,
            'imageUrl': documentSnapshot['image'],
            'Data': date
          });
          Navigator.pushNamedAndRemoveUntil(context, Routers.NAVIGATION_VIEW, (route) => false,arguments: {'value':itemValue});
        }
      }
    }else{
      CustomDialog().dialog(EnumType.INTERNET, myHeight, myWidth);
    }

  }

  void onListen()async{
    if(!speechEnable){
      bool isAvailable = await speech!.initialize(
        onStatus: (status)=> print('status is ${status}'),
        onError: (error)=> print('status is ${error}')
      );

      if(isAvailable){
        setState(() {
          speechEnable = true;
        });

        speech!.listen(
          onResult: (result)=> setState(() {
            desController.text = result.recognizedWords;
          })
        );

      }
    }else{
      setState(() {
        speechEnable = false;
        speech!.stop();
      });
    }
  }

}
