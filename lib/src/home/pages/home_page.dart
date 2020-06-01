import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  SharedPreferences prefs;
  bool isLogin;

  @override
  void initState() {
    super.initState();
  }


  Future<Null> clearPrefs() async {

    prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    setState(() {
      print("login state in Home Page is ${prefs.getBool("isLogin")}");
      Navigator.pushReplacementNamed(context, '/');
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("HOME"),
              SizedBox(height: 30),
              GestureDetector(
                onTap: (){
                  clearPrefs();
                },
                child: Text("Logout",
                style: TextStyle(
                  fontSize: 48,
                  color: Colors.grey
                ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
