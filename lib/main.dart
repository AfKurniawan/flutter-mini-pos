import 'package:flutter/material.dart';
import 'package:flutter_mini_pos/localization/localization.dart';
import 'package:flutter_mini_pos/my_route.dart';
import 'package:flutter_mini_pos/style/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  SharedPreferences prefs;
  bool isLogin;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      initialRoute: '/',
//      onGenerateRoute: MyRoute.generateRoute,
      routes: Routes.getRoute(),
      onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
      theme: AppTheme.lightTheme,

      supportedLocales: [
        Locale('en', 'US'),
        Locale('id', 'ID'),
      ],

      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocaleLanguage in supportedLocales) {
          if (supportedLocaleLanguage.languageCode == locale.languageCode &&
              supportedLocaleLanguage.countryCode == locale.countryCode) {
            return supportedLocaleLanguage;
          }
        }
        return supportedLocales.first;
      },

    );

  }

}




