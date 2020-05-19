import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_deltaprima_pos/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deltaprima_pos/configs/route_arguments.dart';
import 'package:flutter_deltaprima_pos/constants/apis.dart';
import 'package:flutter_deltaprima_pos/dialogs/CustomDialogError.dart';
import 'package:flutter_deltaprima_pos/dialogs/CustomDialogSuccess.dart';
import 'package:flutter_deltaprima_pos/localization/localization.dart';
import 'package:flutter_deltaprima_pos/src/shop/services/create_shop_service.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateShopPage extends StatefulWidget {
  @override
  _CreateShopPageState createState() => _CreateShopPageState();
}

class _CreateShopPageState extends State<CreateShopPage> {
  CreateShopService createShopService;

  TextEditingController controllerShopName = new TextEditingController();
  TextEditingController controllerShopAddress = new TextEditingController();
  TextEditingController controllerShopPhone = new TextEditingController();
  TextEditingController controllerShopKec = new TextEditingController();
  TextEditingController controllerShopKab = new TextEditingController();
  TextEditingController controllerShopKodePos = new TextEditingController();

  RequiredValidator requiredValidator;
  final _formKey = GlobalKey<FormState>();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position currentPosition;
  String password;
  String phone;
  bool isLoading;
  bool isLogin;
  bool isGetLocation;
  SharedPreferences prefs;
  String fullName;
  String firstName;
  String userid;
  String shopname;

  String name;
  String provinces;
  String kabupaten;
  String kecamatan;
  String kelurahan;
  String kodepos;

  String prov;
  String kab;
  String kec;
  String kel;
  String pos;


  @override
  void initState() {
    super.initState();
    createShopService = new CreateShopService();
    isLoading = false;
    isGetLocation = false;
    getPrefs();
    //getCurrentLocation();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullname');
      firstName = fullName.substring(0, fullName.indexOf(" "));
      print("Nama Substring $firstName");
      userid = prefs.getString('userid');

    });
  }

  void createShopAction() async {
    createShopService.createShop(Api.CREATE_SHOP_URL, {
      'name': controllerShopName.text,
      'address': controllerShopAddress.text,
      'phone': controllerShopPhone.text,
      'user_id': '2'
    }).then((response) async {
      prefs = await SharedPreferences.getInstance();
      if (response.error == false) {
        setState(() {
          isLoading = false;
          shopname = response.shop.name;
          print("Nama Toko dari Response $shopname");

          Navigator.pushNamed(context, '/shop_home', arguments: RouteArguments(shopname));

        });
      } else if (response.messages == 'isExist') {
        print("User Exist");
        setState(() {
          failedDialogUserExist(context);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          failedDialog(context);
          print("Register failed");
        });
      }
    }, onError: (error) {
      setState(() {
        isLoading = false;
        print("Register failed");
        failedDialog(context);
      });
    });
  }

  getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        currentPosition = position;
      });
      getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  getAddressFromLatLng() async {

    List<Placemark> p = await geolocator.placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);
    Placemark place = p[0];

    setState(() {
      name      = "${place.name}";
      kelurahan = "${place.subLocality}";
      kecamatan = "${place.locality}";
      kabupaten = "${place.subAdministrativeArea}";
      provinces = "${place.administrativeArea}";
      kodepos   = "${place.postalCode}";

      kec = kecamatan.substring(kecamatan.lastIndexOf(" "));
      kab = kabupaten.substring(kabupaten.lastIndexOf(" "));

      controllerShopAddress.text = "$name, $kelurahan";
      controllerShopKec.text = "$kec".trim();
      controllerShopKab.text = "$kab".trim();
      controllerShopKodePos.text = "$kodepos".trim();

      isGetLocation = false;

      print("Kelurahan anda ${place.subLocality}");
      print("Kecamatan anda $kecamatan");
      print("Kabupaten anda $kabupaten");
      print("Provinsi anda $provinces");
      print("Kode Pos Anda ${place.postalCode}");

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

  Widget getLocationIcon(){
    if(isGetLocation == true){
      return Container(
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    } else {
      return Icon(Icons.my_location, color: Colors.blueGrey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              body()
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left:30.0, right: 30),
        child: progressRegisterButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              //registerButton(),
    );
  }

  Widget appBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40)
              ),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(143, 148, 251, 1),
                Color.fromRGBO(143, 148, 251, .6),
              ])
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        leading: GestureDetector(
            onTap: (){
              Navigator.pushReplacementNamed(context, '/register');
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white)),
        backgroundColor: Colors.blue[400],
        elevation: 3,
        title: Text(AppLocalizations.of(context).translate("appbar_create_shop"), style: TextStyle(
            fontWeight: FontWeight.w300, color: Colors.white, fontSize: 24
        )),
        centerTitle: true,
      ),
    );
  }

  Widget body() {
    return FadeAnimation(
      4,
      Stack(children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            "assets/images/people_shop.png",
            fit: BoxFit.cover,
            alignment: Alignment.bottomLeft,
          ),
        ),
        FadeAnimation(2, Center(child: formGroup())),
      ]),
    );
  }

  Widget formGroup() {
    return Container(
      height: 900,
      color: Color.fromRGBO(255, 255, 255, 0.92),
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30),
        child: Column(
          children: <Widget>[
            header(),
            FadeAnimation(
                1.8,
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      formShopName(),
                      SizedBox(height: 10),
                      formShopPhone(),
                      SizedBox(height: 30),
                      getLocationButton(),
                      formShopAddress(),
                      SizedBox(height: 10),
                      formShopKec(),
                      SizedBox(height: 10),
                      formShopKab(),
                      SizedBox(height: 10),
                      formShopKodePos(),
                      SizedBox(height: 70)

                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      height: MediaQuery.of(context).size.height /4,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 30,
            width: 80,
            height: 70,
            child: FadeAnimation(
                1,
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/light-1.png'))),
                )),
          ),
          Positioned(
            right: 40,
            width: 80,
            height: 140,
            child: FadeAnimation(
                1.3,
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/light-2.png'))),
                )),
          ),
          Positioned(
            child: FadeAnimation(
                1.6,
                Container(
                  padding: EdgeInsets.only(top: 20, right: 30),
                  margin: EdgeInsets.only(top: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Hai",
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 30,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            flex: 2,
                            child: Text(
                              "$firstName",
                              //textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.green[400],
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate("register_shop_text"),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                           color: Color.fromRGBO(143, 148, 251, 1),
                            fontSize: 30,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  Widget formShopName() {
    return Container(
      child: TextFormField(
        validator: RequiredValidator(
            errorText:
                AppLocalizations.of(context).translate("error_form_entry")),
        controller: controllerShopName,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400], width: 1.5),
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
                .translate("hint_register_shop_name"),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget formShopAddress() {

      return Container(
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          validator: RequiredValidator(
              errorText:
              AppLocalizations.of(context).translate("error_form_entry")),
          controller: controllerShopAddress,
          decoration: InputDecoration(

              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[600], width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400], width: 1.5),
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
                  .translate("hint_register_shop_address"),
              hintStyle: TextStyle(color: Colors.grey[400])),
        ),
      );
    }

  Widget formShopKec() {

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        validator: RequiredValidator(
            errorText:
            AppLocalizations.of(context).translate("error_form_entry")),
        controller: controllerShopKec,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400], width: 1.5),
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
                .translate("hint_register_shop_kecamatan"),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget formShopKab() {

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        validator: RequiredValidator(
            errorText:
            AppLocalizations.of(context).translate("error_form_entry")),
        controller: controllerShopKab,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400], width: 1.5),
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
                .translate("hint_register_shop_kabupaten"),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget formShopKodePos() {

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: RequiredValidator(
            errorText:
            AppLocalizations.of(context).translate("error_form_entry")),
        controller: controllerShopKodePos,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400], width: 1.5),
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
                .translate("hint_register_shop_kodepos"),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget formShopPhone() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: TextFormField(
        onChanged: (val) => phone = val,
        validator: RequiredValidator(
            errorText:
                AppLocalizations.of(context).translate("error_form_entry")),
        controller: controllerShopPhone,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[600], width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400], width: 1.5),
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
                .translate("hint_register_shop_phone"),
            hintStyle: TextStyle(color: Colors.grey[400])),
      ),
    );
  }

  Widget getLocationButton(){
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(AppLocalizations.of(context).translate("register_get_location_button")),
            SizedBox(width: 30),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 12.0),
              child: InkWell(
                  onTap: () {
                    setState(() {
                      isGetLocation = true;
                      getCurrentLocation();
                    });
                  },
                  child: getLocationIcon()), // myIcon is a 48px-wide widget.
            )
          ],
        ),
      ),
    );
  }

  Widget registerButton() {
    return FadeAnimation(
        2,
        InkWell(
          onTap: () {
            print("Button Create clicked");
            if (_formKey.currentState.validate()) {
              print("Create Shop Start");

              setState(() {
                isLoading = true;
                createShopAction();
              });
            }
          },
          splashColor: Color.fromRGBO(143, 148, 251, 1),
          child: Container(
            height: 55,
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

  Widget progressRegisterButton(){
    if(isLoading == true){
      return FadeAnimation(
          2,
          Container(
            height: 55,
            //color: Color.fromRGBO(143, 148, 251, .6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(143, 148, 251, 1),
                  Color.fromRGBO(143, 148, 251, .6),
                ])
            ),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ));

    } else {

      return registerButton();
    }

  }
}
