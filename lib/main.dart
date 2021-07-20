import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:delivery_template/config/theme.dart';
import 'package:delivery_template/model/account.dart';
import 'package:delivery_template/model/pref.dart';
import 'package:delivery_template/ui/login/createaccount.dart';
import 'package:delivery_template/ui/login/forgot.dart';
import 'package:delivery_template/ui/login/login.dart';
import 'package:delivery_template/ui/main/mainscreen.dart';
import 'package:delivery_template/ui/start/splash.dart';
import 'config/lang.dart';
import 'package:firebase_core/firebase_core.dart';
import 'model/server/settings.dart';

//
// Theme
//
AppThemeData theme = AppThemeData();
//
// Language data
//
Lang strings = Lang();
//
// Account
//
Account account = Account();
Pref pref = Pref();
var appSettings = AppSettings();

Future<void> main() async {
  theme.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  pref.init().then((instance) {
    var id = pref.get(Pref.language);
    var lid = Lang.english;
    if (id.isNotEmpty)
      lid = int.parse(id);
    strings.setLang(lid);  // set default language - English
    runApp(AppFoodDelivery());
  });
}

class AppFoodDelivery  extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var _theme = ThemeData(
      fontFamily: 'Raleway',
      primarySwatch: theme.primarySwatch,
    );

    if (theme.darkMode){
      _theme = ThemeData(
        fontFamily: 'Raleway',
        brightness: Brightness.dark,
        unselectedWidgetColor:Colors.white,
        primarySwatch: theme.primarySwatch,
      );
    }

    settings((AppSettings value) {
      appSettings = value;
      var user = pref.get(Pref.userSelectLanguage);
      if (user != "true")
        strings.setLang(appSettings.appLanguage);  // set default language
    }, (_){});

    return MaterialApp(
      title: strings.get(10),  // Delivery Box App
      debugShowCheckedModeBanner: false,
      theme: _theme,
      initialRoute: '/splash',
      //initialRoute: '/main',
      routes: {
        '/splash': (BuildContext context) => SplashScreen(),
        '/login': (BuildContext context) => LoginScreen(),
        '/forgot': (BuildContext context) => ForgotScreen(),
        '/createaccount': (BuildContext context) => CreateAccountScreen(),
        '/main': (BuildContext context) => MainScreen(),
      },
    );
  }
}


dprint(String str){
  if (!kReleaseMode) print(str);
}