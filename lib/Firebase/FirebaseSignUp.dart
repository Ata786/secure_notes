import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../Components/InternetDialog.dart';
import '../Routes/Routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Bloc/SignUpBloc/bloc/sign_up_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';



class FirebaseSignUp{

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseSignUp();


  void registerUser(BuildContext context, String _name, String _email, String _password,File file,double myHeight,double myWidth) async {

    if (_name == '') {
      context.read<SignUpBloc>().add(SignUpNameEvent('Enter Name'));
    } else if (_email == '') {
      context.read<SignUpBloc>().add(SignUpEmailEvent('Enter Email'));
    } else if (_password == '') {
      context.read<SignUpBloc>().add(SignUpPasswordEvent('Enter Password'));
    } else {

      showDialog(
          context: context,
          builder: (context){
            return CustomDialog().dialog(EnumType.PROGRESS, myHeight, myWidth);
          }
      );

        Reference img = firebaseStorage.ref().child('files/${file.path}');
        await img.putFile(file);

        String url = await img.getDownloadURL();

        try {
          UserCredential user = await firebaseAuth.createUserWithEmailAndPassword(
              email: _email, password: _password);

          await firestore.collection('User').doc(user.user!.uid).set({
            "userName": _name,
            "email": _email,
            "image": url,
          });

          Navigator.pushNamedAndRemoveUntil(context, Routers.SIGNIN ,(route) => false);

        }on FirebaseAuthException catch(e) {
          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: 'Error:- ${e.code}');
        }
    }
    

  }


}