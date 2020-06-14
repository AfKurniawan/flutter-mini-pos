import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  bool isLogin;
  SharedPreferences prefs;



  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    print("Login value from preferences is ${prefs.getBool('isLogin')}");
    if(prefs.getBool('isLogin') == true){
      setState(() {
        startTime();
        print("Login status in Spalsh Page $isLogin");
      });
    } else {
      Navigator.pushReplacementNamed(context, '/login_page');
    }
  }

  startTime() async {
    var duration = new Duration(seconds: 5);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacementNamed(context, '/main_page');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: splashWidget(),
    );
  }

  Widget splashWidget(){
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 100,
              child: Image.asset("assets/images/splash_logo.png"),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            SizedBox(height: 40),
//            CircularProgressIndicator(
//              backgroundColor: Colors.white,
//              strokeWidth: 1,
//            )
          ],
        ),
      ),
    );

  }
}
