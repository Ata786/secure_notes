import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Components/Colors.dart';
import 'Bloc/CheckBox/check_box_bloc.dart';
import 'Bloc/CheckEmpty/check_empty_bloc.dart';
import 'Bloc/DeleteButton/delete_button_bloc.dart';
import 'Bloc/SignUpBloc/bloc/sign_up_bloc.dart';
import 'Bloc/bloc.dart';
import 'Routes/Routes.dart';
import 'package:firebase_core/firebase_core.dart';
import './Bloc/ButtonChange/button_change_bloc.dart';
import 'Bloc/RequestButton/request_bt_bloc.dart';
import 'Bloc/PostBloc/post_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
// 544afa
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PostBloc>(
      create: (context) => PostBloc(),
      child: BlocProvider<RequestBtBloc>(
        create: (context) => RequestBtBloc(),
        child: BlocProvider<CheckEmptyBloc>(
          create: (context) => CheckEmptyBloc(),
          child: BlocProvider<DeleteButtonBloc>(
            create: (context) => DeleteButtonBloc(),
            child: BlocProvider<CheckBoxBloc>(
              create: (context) => CheckBoxBloc(),
              child: BlocProvider<ButtonChangeBloc>(
                create: (context) => ButtonChangeBloc(),
                child: BlocProvider<SignUpBloc>(
                  create: (context) => SignUpBloc(),
                  child: BlocProvider<BlocIndex>(
                    create: (context) => BlocIndex(),
                    child: MaterialApp(
                      debugShowCheckedModeBanner: false,
                      title: 'Secure_Notes',
                      onGenerateRoute: Routers.generateRoute,
                      initialRoute: Routers.SPLASH,
                      theme: ThemeData(
                          colorScheme: ColorScheme.fromSwatch().copyWith(
                              primary: Color(CustomColor.PRIMARY_COLOR)
                          )
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
