import 'package:flutter/material.dart';
import '../Pages/BottomNavigation.dart';
import '../Pages/CreateNotes.dart';
import '../Pages/SignIn.dart';
import '../Pages/SignUp.dart';
import '../Pages/SplashScreen.dart';
import '../Pages/UpdateNotes.dart';
import '../Pages/SearchPage.dart';

class Routers {

  static const String SIGNUP = '/signUp';
  static const String SIGNIN = '/signIn';
  static const String NAVIGATION_VIEW = '/navigationView';
  static const String CREATE_NOTES = '/create_noes';
  static const String SPLASH = '/splash';
  static const String UPDATE_NOTES = '/updateNotes';
  static const String SEARCH_PAGE = '/searchPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SPLASH:
        return MaterialPageRoute(settings: settings,builder: (_) => SplashScreen());
        break;
      case SIGNUP:
        return MaterialPageRoute(settings: settings,builder: (_) => SignUpPage());
        break;
      case SIGNIN:
        return MaterialPageRoute(settings: settings,builder: (_) => SignIn());
        break;
      case NAVIGATION_VIEW:
        return MaterialPageRoute(settings: settings,builder: (_) => BottomNavigation());
        break;
      case CREATE_NOTES:
        return MaterialPageRoute(settings: settings,builder: (_) => CreateNotes());
        break;
      case UPDATE_NOTES:
        return MaterialPageRoute(settings: settings,builder: (_) => UpdateNotes());
        break;
      case SEARCH_PAGE:
        return MaterialPageRoute(settings: settings,builder: (_) => SearchPage());
      default:
        return MaterialPageRoute(
          settings: settings,
            builder: (_) => MaterialApp(
                  home: Scaffold(
                    body: Center(
                      child: Text('No route define for ${settings.name}'),
                    ),
                  ),
                ));
    }
  }
}
