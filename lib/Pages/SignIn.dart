import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Components/EditText.dart';
import '../Components/Buttons.dart';
import '../Routes/Routes.dart';
import '../Components/Colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_notes/Bloc/bloc.dart';
import 'package:secure_notes/Bloc/bloc_event.dart';
import '../Components/InternetDialog.dart';
import '../Components/CheckInternet.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);

  TextEditingController signIn_Email = TextEditingController();
  TextEditingController signIn_Password = TextEditingController();


  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    return SafeArea(child: Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: myHeight / 10,),
              SvgPicture.asset(
                'assets/signin_svg.svg',
                height: myHeight / 4,
                width: myWidth / 3,
              ),
              SizedBox(height: myHeight / 15,),
              Text('Log In',style: TextStyle(fontSize: myHeight / 25),),
              SizedBox(height: myHeight / 10,),
              EditText(
                fieldEnable: true,
                textInputType: TextInputType.emailAddress,
                editWidth: myWidth / 1.3,
                controller: signIn_Email,
                hintText: 'Enter Email',
                prefix: Icon(Icons.email),
                filled: true,
                filledColor: Color(0xffd6d5e7),
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0),
                helperText: '',
              ),
              SizedBox(height: myHeight / 40,),
              EditText(
                fieldEnable: true,
                textInputType: TextInputType.visiblePassword,
                editWidth: myWidth / 1.3,
                controller: signIn_Password,
                hintText: 'Enter Password',
                prefix: Icon(Icons.lock),
                filled: true,
                filledColor: Color(0xffd6d5e7),
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0),
                helperText: '',
              ),
              SizedBox(height: myHeight / 20,),
              Button(
                pressed: ()async{
                  context.read<BlocIndex>().add(SetIndexEvent());
                  bool connection = await CheckConnection.checkInternet(context);
                  if(connection == true){
                    showDialog(context: context,
                        builder: (context){
                      return  CustomDialog().dialog(EnumType.PROGRESS, myHeight, myWidth);
                        });
                    signInUser(context,signIn_Email.text,signIn_Password.text);
                  }else{
                    showDialog(
                      context: context,
                        builder: (context){
                        return  CustomDialog().dialog(EnumType.INTERNET, myHeight, myWidth);
                        },
                    );
                  }

                },
                btHeight: myHeight / 15,
                btWidth: myWidth / 1.3,
                btText: 'Sign In',
                buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Color(CustomColor.PRIMARY_COLOR),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    )
                ),
                btTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: myHeight / 50
                ),
              ),
              SizedBox(height: myHeight / 60,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('If already have not account? '),
                  GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, Routers.SIGNUP);
                      },
                      child: Text('Sign Up',style: TextStyle(color: Colors.red,fontSize: myHeight / 55),)),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  void signInUser(BuildContext context,String _email,String _password)async{

    if(_email == '' || _password == ''){
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Please give email and password both');
    }else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: _email,
            password: _password
        );
        if (userCredential.user != null) {
          // Navigator.pushNamedAndRemoveUntil(
          //     context, Routers.NAVIGATION_VIEW, (route) => false);

          Navigator.pushNamed(context, Routers.NAVIGATION_VIEW);
        }
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: '${e.code}');
      }
    }
  }

}