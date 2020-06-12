import 'package:flutter/cupertino.dart';
import 'package:flutter_mini_pos/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mini_pos/constants/apis.dart';
import 'package:flutter_mini_pos/dialogs/CustomDialogError.dart';
import 'package:flutter_mini_pos/dialogs/CustomDialogSuccess.dart';
import 'package:flutter_mini_pos/localization/localization.dart';
import 'package:flutter_mini_pos/src/register/services/register_service.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

ProgressDialog pd;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterService registerApiService;
  TextEditingController controllerFullName = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPhone = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  RequiredValidator requiredValidator;
  final _formKey = GlobalKey<FormState>();

  String password;
  String phone;
  bool isLoading;
  bool isLogin;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    registerApiService = new RegisterService();
    isLoading = false;
  }



  void signUpAction() async {
    registerApiService.register(Api.REGISTER_URL, {
      'full_name': controllerFullName.text,
      'email': controllerEmail.text,
      'phone': controllerPhone.text,
      'password': controllerPassword.text
    }).then((response) async {
      prefs = await SharedPreferences.getInstance();
      if (response.error == false) {
        print("Response Email ${response.user.email}");
        print("Response Phone ${response.user.phone}");
        print("Response Full Name ${response.user.fullName}");
        setState(()  {
          prefs.setBool('isLogin', true);
          prefs.setString('userid', response.user.id);
          prefs.setString('email', response.user.email);
          prefs.setString('phone', response.user.phone);
          prefs.setString('fullname', response.user.fullName);
          isLoading = false;
          successDialog(context);
        });
      } else if(response.messages == 'isExist'){
        print("User Exist");
        setState(() {
          failedDialogUserExist(context);
          isLoading = false;
        });


      } else {
        setState(() {
          isLoading = false;
          failedDialog(context);
          print("Register failed Code");
        });

      }
    }, onError: (error) {
      setState(() {
        isLoading = false;
        print("Register failed Network");
        failedDialog(context);
      });

    });
  }

  failedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialogError(
        title: AppLocalizations.of(context)
            .translate("title_register_dialog_error"),
        description: AppLocalizations.of(context)
            .translate("description_register_dialog_error"),
        buttonText: AppLocalizations.of(context)
            .translate("button_register_dialog_error"),
      ),
    );
  }

  failedDialogUserExist(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialogError(
        title: AppLocalizations.of(context)
            .translate("title_register_dialog_user_exist"),
        description: AppLocalizations.of(context)
            .translate("description_register_dialog_user_exist"),
        buttonText: AppLocalizations.of(context)
            .translate("button_register_dialog_user_exist"),
      ),
    );
  }

  successDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialogSuccess(
        title: AppLocalizations.of(context)
            .translate('title_register_dialog_success'),
        description: AppLocalizations.of(context)
            .translate('description_register_dialog_success'),
        buttonText: AppLocalizations.of(context)
            .translate('button_register_dialog_success'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,


        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                header(),
                isLoading == true
                    ? progressDialog()
                    : body()
              ],
            ),
          ),
        ));
  }

  Widget body(){
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: <Widget>[
          FadeAnimation(
              1.8,
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    formFullName(),
                    SizedBox(height: 10),
                    formEmail(),
                    SizedBox(height: 10),
                    formPhone(),
                    SizedBox(height: 10),
                    formPassword(),
                    SizedBox(height: 10),
                    formRepeatPassword(),
                  ],
                ),
              )),
          SizedBox(
            height: 30,
          ),
          registerButton(),
          SizedBox(
            height: 70,
          ),
          toLoginFlatButton(),
        ],
      ),
    );
  }

  Widget progressDialog(){
    return Center(
      child: Container(
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(143, 148, 251, 1),
                Color.fromRGBO(143, 148, 251, .6),
              ])),
          padding: EdgeInsets.only(right: 10, left: 10, top: 20, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(width: 30),
              Text("Loading...",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                  ))
            ],
          )),
    );
  }

  Widget header() {
    return Container(
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
                          image: AssetImage('assets/images/light-1.png'))),
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
                          image: AssetImage('assets/images/light-2.png'))),
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
                          image: AssetImage('assets/images/clock.png'))),
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
                      AppLocalizations.of(context)
                          .translate("register_welcome_text"),
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
    );
  }

  Widget formFullName() {
    return Container(
      child: TextFormField(
        validator: RequiredValidator(
            errorText:
            AppLocalizations.of(context).translate("error_form_entry")),
        controller: controllerFullName,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[500], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: AppLocalizations.of(context)
                .translate("form_full_name_hint"),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget formEmail() {
    final emailValidator = MultiValidator([
      RequiredValidator(
          errorText:
              AppLocalizations.of(context).translate("error_form_entry")),
      EmailValidator(
          errorText:
              AppLocalizations.of(context).translate("error_email_validatiom")),
    ]);
    return Container(
      child: TextFormField(
        validator: emailValidator,
        controller: controllerEmail,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[500], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: AppLocalizations.of(context)
                .translate("form_email_register_hint"),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget formPhone() {
    final phoneValidator = MultiValidator([
      RequiredValidator(
          errorText:
              AppLocalizations.of(context).translate("error_form_entry")),
      MinLengthValidator(10,
          errorText: AppLocalizations.of(context)
              .translate('error_long_phone_character')),
      //MinLengthValidator(10, errorText: "Jilak"),
    ]);

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        onChanged: (val) => phone = val,
        validator: phoneValidator,
        controller: controllerPhone,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[500], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: AppLocalizations.of(context).translate("form_phone_hint"),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget formPassword() {
    final passwordValidator = MultiValidator([
      RequiredValidator(
          errorText:
              AppLocalizations.of(context).translate("error_form_entry")),
      MinLengthValidator(6,
          errorText: AppLocalizations.of(context)
              .translate('error_long_password_character')),
    ]);

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        onChanged: (val) => password = val,
        // assign the the multi validator to the TextFormField validator
        validator: passwordValidator,
        controller: controllerPassword,
        obscureText: true,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[500], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText:
                AppLocalizations.of(context).translate("form_password_hint"),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget formRepeatPassword() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        validator: (val) => MatchValidator(
                errorText: AppLocalizations.of(context)
                    .translate("error_repeat_password_validator"))
            .validateMatch(val, password),
        obscureText: true,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[500], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red[300], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            hintText: AppLocalizations.of(context)
                .translate("form_repeat_password_hint"),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget registerButton() {
    return FadeAnimation(
        2,
        InkWell(
          onTap: () {
            print("Button Register clicked");
            if (_formKey.currentState.validate()) {
              print("Validator Valid");

              setState(() {
                isLoading = true;
                signUpAction();
              });
            }
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
                AppLocalizations.of(context).translate('register_button'),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ));
  }

  Widget toLoginFlatButton() {
    return FadeAnimation(
        1.5,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate("allready_registered"),
              style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),
            ),
            GestureDetector(
              onTap: () {
                //Navigator.pushNamed(context, '/');
                Navigator.pushReplacementNamed(context, "/login");
              },
              child: Text(
                AppLocalizations.of(context).translate("login_flat_button"),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(143, 148, 251, 3)),
              ),
            ),
          ],
        ));
  }
}
