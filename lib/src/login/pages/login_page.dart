import 'package:flutter_deltaprima_pos/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deltaprima_pos/constants/apis.dart';
import 'package:flutter_deltaprima_pos/localization/localization.dart';
import 'package:flutter_deltaprima_pos/src/login/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  LoginService loginService;
  SharedPreferences prefs;
  bool isLogin;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  String userid ;
  String fullname;
  String address;
  String usertype;
  String shopid;

  @override
  void initState() {
    super.initState();
    loginService = new LoginService();
    getPrefs();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    print("Login value from preferences is ${prefs.getBool('isLogin')}");
      if(prefs.getBool('isLogin') == true){
        setState(() {
          Navigator.pushReplacementNamed(context, '/main_page');
        });

      }
  }

  loginAction() async {
    loginService.login(Api.LOGIN_URL,
        { 'email': emailController.text,
          'phone': emailController.text,
          'password': passwordController.text

        }).then((response){
       if(response.error == false){
         setState(() {
           userid = response.user.id;
           fullname = response.user.fullName;
           address = response.user.address;
           usertype = response.user.userType;
           shopid = response.user.shopId;
           saveUserPrefs();
           Navigator.pushReplacementNamed(context, '/main_page');
         });


       }

    });
  }

  saveUserPrefs() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', userid);
    prefs.setString('fullname', fullname);
    prefs.setString('address', address);
    prefs.setString('usertype', usertype);
    prefs.setString('shopid', shopid);
    prefs.setBool('isLogin', true);

    print("USERID LOGINPAGE $userid");
    print("FULLNAME LOGINPAGE $fullname");
    print("ADDRESS LOGINPAGE $address");
    print("USERTYPE LOGINPAGE $usertype");
    print("SHOPID LOGINPAGE $shopid");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 100,
                        child: FadeAnimation(
                            1,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.3,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              padding: EdgeInsets.all(40),
                              margin: EdgeInsets.only(top: 90),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context).translate("welcome_text"),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          1.8,
                          Column(
                            children: <Widget>[
                              formEmailWidget(),
                              formPasswordWidget()
                            ],
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      buttonLoginWidget(),
                      SizedBox(
                        height: 70,
                      ),
                      FadeAnimation(
                          1.5,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context).translate("not_registered"),
                                style: TextStyle(
                                    color: Color.fromRGBO(143, 148, 251, 1)),
                              ),

                              GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: Text(
                                  AppLocalizations.of(context).translate("daftar_flat_button"),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(143, 148, 251, 1)),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget formEmailWidget(){
    return Container(
      child: TextFormField(
        controller: emailController,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[500], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),

            hintText: AppLocalizations.of(context).translate("form_email_hint"),
            hintStyle:
            TextStyle(color: Colors.grey[400])),
      ),
    );
  }
  Widget formPasswordWidget(){
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[500], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),

            hintText: AppLocalizations.of(context).translate("form_password_hint"),
            hintStyle:
            TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget buttonLoginWidget(){
    return  FadeAnimation(
        2,
        InkWell(
          onTap: (){
            print("Button Login Clicked");
            loginAction();
          },
          splashColor: Color.fromRGBO(143, 148, 251, 1),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(143, 148, 251, 1),
                  Color.fromRGBO(143, 148, 251, .6),
                ])),
            child: Center(
              child: Text(
                AppLocalizations.of(context).translate('login_button'),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
    );
  }
}
