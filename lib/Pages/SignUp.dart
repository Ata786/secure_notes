import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:secure_notes/Bloc/bloc.dart';
import 'package:secure_notes/Bloc/bloc_event.dart';
import '../Bloc/SignUpBloc/bloc/sign_up_bloc.dart';
import '../Bloc/bloc_state.dart';
import '../Components/EditText.dart';
import '../Components/Buttons.dart';
import '../Routes/Routes.dart';
import '../Components/Colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import '../Components/CheckInternet.dart';
import '../Components/InternetDialog.dart';
import '../Firebase/FirebaseSignUp.dart';


class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUpPage();
  }
}

class _SignUpPage extends State<SignUpPage> {

  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  XFile? image;
  File? file;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getImage(BuildContext context) async {
    image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      file = File(image!.path);
      context.read<BlocIndex>().add(ImageEvent(file!));
    }
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
          child: Scaffold(
            body: Container(
              height: myHeight,
              width: myWidth,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Positioned(
                            top: -myHeight / 15,
                            left: -myWidth / 8,
                            child: Container(
                              height: myHeight / 4,
                              width: myWidth / 2,
                              decoration: BoxDecoration(
                                  color: Color(CustomColor.PRIMARY_COLOR),
                                  shape: BoxShape.circle),
                            )),
                        Positioned(
                            top: myHeight / 10,
                            right: -myWidth / 6,
                            child: Container(
                              height: myHeight / 6,
                              width: myWidth / 3,
                              decoration: BoxDecoration(
                                  color: Color(CustomColor.PRIMARY_COLOR),
                                  shape: BoxShape.circle),
                            )),
                        SingleChildScrollView(
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: myHeight / 7,
                                  ),
                                  Text(
                                    'Welcome',
                                    style: TextStyle(
                                      fontSize: myHeight / 25,
                                    ),
                                  ),
                                  SizedBox(
                                    height: myHeight / 12,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      getImage(context);
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(color: Color(0xffd3d3d3)),
                                        ),
                                        child: BlocBuilder<BlocIndex, BlocState>(
                                          builder: (context, state) {
                                            if (state is SetIndexState) {
                                              return Image.asset('assets/user_icon.png',
                                                  height: myHeight / 10,
                                                  width: myWidth / 2);
                                            } else if (state is ImageState) {
                                              return CircleAvatar(
                                                backgroundImage: FileImage(state.file),
                                                radius: myHeight / 20,
                                              );
                                            } else {
                                              return Image.asset('assets/user_icon.png',
                                                  height: myHeight / 10,
                                                  width: myWidth / 2);
                                            }
                                          },
                                        )),
                                  ),
                                  SizedBox(
                                    height: myHeight / 80,
                                  ),
                                  Text(
                                    'Tap to change',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(
                                    height: myHeight / 30,
                                  ),
                                  BlocBuilder<SignUpBloc, SignUpState>(
                                    builder: (context, state) {
                                      if (state is SignUpInitial) {
                                        return initialTextFiled(myWidth, myHeight, '');
                                      } else if (state is SignUpNameState) {
                                        return NameTextField(
                                            myWidth, myHeight, state.name,'','');
                                      } else if (state is SignUpEmailState) {
                                        return EmailTextField(
                                            myWidth, myHeight,'',state.email,'');
                                      } else if (state is SignUpPasswordState) {
                                        return PasswordTextFile(
                                            myWidth, myHeight,'','',state.password);
                                      } else {
                                        return initialTextFiled(myWidth, myHeight, '');
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: myHeight / 20,
                                  ),
                                  Button(
                                    pressed: () async {
                                      bool conn = await CheckConnection.checkInternet(context);
                                      if(conn == true){
                                        if(file != null){
                                          FirebaseSignUp().registerUser(context, userName.text.trim(), email.text.trim(), password.text.trim(),file!,myHeight,myWidth);
                                        }else{
                                          Fluttertoast.showToast(msg: 'Image is null');
                                        }
                                      }else{
                                        showDialog(
                                            context: context,
                                            builder: (context){
                                          return CustomDialog().dialog(EnumType.INTERNET,myHeight,myWidth);
                                            }
                                        );
                                      }
                                    },
                                    btHeight: myHeight / 15,
                                    btWidth: myWidth / 1.3,
                                    btText: 'Sign Up',
                                    buttonStyle: ElevatedButton.styleFrom(
                                        backgroundColor: Color(CustomColor.PRIMARY_COLOR),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0))),
                                    btTextStyle: TextStyle(
                                        color: Colors.white, fontSize: myHeight / 50),
                                  ),
                                  SizedBox(
                                    height: myHeight / 60,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('If already have an account? '),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context, Routers.SIGNIN);
                                          },
                                          child: Text(
                                            'Sign In',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: myHeight / 55),
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ));
  }

  Widget NameTextField(double myWidth, double myHeight, String helperName,String helperEmail,String helperPassword) {
    return Column(
      children: [
        editText(
            TextInputType.name,
            myWidth / 1.3,
            userName,
            'Enter UserName',
            Icon(Icons.account_box),
            true,
            Color(0xffd6d5e7),
            BorderSide.none,
            BorderRadius.circular(10.0),
            helperName),
        SizedBox(
          height: myHeight / 40,
        ),
        editText(
            TextInputType.emailAddress,
            myWidth / 1.3,
            email,
            'Enter Email',
            Icon(Icons.email),
            true,
            Color(0xffd6d5e7),
            BorderSide.none,
            BorderRadius.circular(10.0),
            helperEmail),
        SizedBox(
          height: myHeight / 40,
        ),
        editText(
            TextInputType.visiblePassword,
            myWidth / 1.3,
            password,
            'Enter Password',
            Icon(Icons.lock),
            true,
            Color(0xffd6d5e7),
            BorderSide.none,
            BorderRadius.circular(10.0),
            helperPassword),
      ],
    );
  }

  Widget EmailTextField(double myWidth, double myHeight, String helperName,String helperEmail,String helperPassword) {
    return Column(
      children: [
        editText(
            TextInputType.name,
            myWidth / 1.3,
            userName,
            'Enter UserName',
            Icon(Icons.account_box),
            true,
            Color(0xffd6d5e7),
            BorderSide.none,
            BorderRadius.circular(10.0),
            helperName),
        SizedBox(
          height: myHeight / 40,
        ),
        editText(
            TextInputType.emailAddress,
            myWidth / 1.3,
            email,
            'Enter Email',
            Icon(Icons.email),
            true,
            Color(0xffd6d5e7),
            BorderSide.none,
            BorderRadius.circular(10.0),
            helperEmail),
        SizedBox(
          height: myHeight / 40,
        ),
        editText(
            TextInputType.visiblePassword,
            myWidth / 1.3,
            password,
            'Enter Password',
            Icon(Icons.lock),
            true,
            Color(0xffd6d5e7),
            BorderSide.none,
            BorderRadius.circular(10.0),
            helperPassword),
      ],
    );
  }

  Widget PasswordTextFile(double myWidth, double myHeight, String helperName,String helperEmail,String helperPassword) {
    return Column(
      children: [
        editText(
            TextInputType.name,
            myWidth / 1.3,
            userName,
            'Enter UserName',
            Icon(Icons.account_box),
            true,
            Color(0xffd6d5e7),
            BorderSide.none,
            BorderRadius.circular(10.0),
            helperName),
        SizedBox(
          height: myHeight / 40,
        ),
        editText(
            TextInputType.emailAddress,
            myWidth / 1.3,
            email,
            'Enter Email',
            Icon(Icons.email),
            true,
            Color(0xffd6d5e7),
            BorderSide.none,
            BorderRadius.circular(10.0),
            helperEmail),
        SizedBox(
          height: myHeight / 40,
        ),
        editText(
            TextInputType.visiblePassword,
            myWidth / 1.3,
            password,
            'Enter Password',
            Icon(Icons.lock),
            true,
            Color(0xffd6d5e7),
            BorderSide.none,
            BorderRadius.circular(10.0),
            helperPassword),
      ],
    );
  }

  Widget initialTextFiled(double myWidth, double myHeight, String helper) {
    return Column(
      children: [
        editText(
            TextInputType.name,
            myWidth / 1.3,
            userName,
            'Enter UserName',
            Icon(Icons.account_box),
            true,
            Color(0xffd6d5e7),
            BorderSide.none,
            BorderRadius.circular(10.0),
            helper),
        SizedBox(
          height: myHeight / 40,
        ),
        editText(
            TextInputType.emailAddress,
            myWidth / 1.3,
            email,
            'Enter Email',
            Icon(Icons.email),
            true,
            Color(0xffd6d5e7),
            BorderSide.none,
            BorderRadius.circular(10.0),
            helper),
        SizedBox(
          height: myHeight / 40,
        ),
        editText(
            TextInputType.visiblePassword,
            myWidth / 1.3,
            password,
            'Enter Password',
            Icon(Icons.lock),
            true,
            Color(0xffd6d5e7),
            BorderSide.none,
            BorderRadius.circular(10.0),
            helper),
      ],
    );
  }

  Widget editText(
      TextInputType _type,
      double width,
      TextEditingController _controller,
      String hint,
      Icon icon,
      bool fill,
      Color fillColor,
      BorderSide border,
      BorderRadius radius,
      String helperText) {
    return EditText(
      fieldEnable: true,
      textInputType: _type,
      editWidth: width,
      controller: _controller,
      hintText: hint,
      prefix: icon,
      filled: fill,
      filledColor: fillColor,
      borderSide: border,
      borderRadius: radius,
      helperText: helperText,
      helperStyle: TextStyle(color: Colors.red),
    );
  }



}
