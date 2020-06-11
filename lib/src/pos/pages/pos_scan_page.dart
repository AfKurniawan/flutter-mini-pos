
//class PosScanPage extends StatefulWidget {
//  PosScanPage({Key key, this.model}) : super(key: key);
//  final Shops model;
//
//  @override
//  _PosScanPageState createState() => _PosScanPageState();
//}
//
//class _PosScanPageState extends State<PosScanPage> {
//  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//  bool isFav = false;
//  GetProductService getProductService;
//  AddCartService addCartService;
//  LabelCountService labelCountService;
//  SharedPreferences prefs;
//  bool isLogin;
//  Shops model;
//  Item item;
//  String name;
//  String images;
//  String price;
//  String productid;
//  String takeBarcode = "";
//  String barcode = "";
//  String variant;
//  String shopid;
//  String labelcartcount;
//  String fullname;
//  bool isNotFound;
//  String userid;
//  bool isNotScanned;
//  bool errorBarcode;
//  bool isBtnScan;
//  TextEditingController quantityController = new TextEditingController();
//  TextEditingController receiveController = new TextEditingController();
//  TextEditingController searchController = new TextEditingController();

//  List<Cart> cartlist = [];
//  String filter;
//
//
//  List<Cart> _userDetails = [];
//  List<Cart> _searchResult = [];
//
//
//
//  @override
//  void initState() {
//
//    isBtnScan = true;
//    model = widget.model;
//    getProductService = new GetProductService();
//    addCartService = new AddCartService();
//    labelCountService = new LabelCountService();
//    getPrefs();
//    super.initState();
//
//  }
//
//
//  getPrefs() async {
//    prefs = await SharedPreferences.getInstance();
//    setState(() {
//      print("Nama Substring, $userid");
//      userid = prefs.getString('userid');
//      shopid = prefs.getString('shopid');
//      fullname = prefs.getString('fullname');
//      getLabelCartCount();
//
//      //startBarcodeScanStream();
//    });
//  }
//
//  void getLabelCartCount() async {
//    labelCountService.getLabelCount(Api.GET_LABEL_COUNT,
//        {'user_id': userid, 'shop_id': shopid}).then((response) {
//      if (response.error == false) {
//        setState(() {
//          labelcartcount = response.count.count;
//          print("Total Cart $labelcartcount");
//        });
//      }
//    });
//  }
//

//

//
//  Future<List<Cart>> getCartList() async {
//    var res = await http.post(Uri.encodeFull(Api.GET_CART_LIST),
//        headers: {"Accept": "application/json"},
//        body: {'userid': userid, 'shopid': shopid});
//    if (res.statusCode == 200) {
//      var data = json.decode(res.body);
//      var rest = data["cart"] as List;
//      print(res.body);
//      cartlist = rest.map<Cart>((j) => Cart.fromJson(j)).toList();
//    }
//    return cartlist;
//  }
//

//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: myAppBar(),
//        drawer: DrawerMenu(),
//        body: barcode == ""
//            ? FadeAnimation(1,
//            singleChildScrollView())
//            : detailProductWidget(),
//        bottomNavigationBar: isBtnScan == true
//            ? Padding(
//                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 8, top: 8),
//                child: scanButtonNew(),
//              )
//            : Padding(
//                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 8, top: 8),
//                child: showCartButton(),
//              ));
//  }
//
//  Widget myAppBar(){
//    return new AppBar(
//      centerTitle: true,
//      title: Text("POS",
//        style: TextStyle(color: Colors.black),
//      ),
//      elevation: 1,
//      backgroundColor: Theme.of(context).backgroundColor,
//      leading: IconButton(
//        icon: Icon(Icons.short_text,
//          size: 30,
//          color: Colors.black,
//        ),
//        onPressed: () => Scaffold.of(context).openDrawer(),
//      ),
//      actions: <Widget>[
//        FadeAnimation(1,
//          IconButton(
//            icon: IconBadge(
//              icon: LineariconsFree.cart,
//              size: 24.0,
//              count: labelcartcount,
//            ),
//            color: LightColor.grey,
//            onPressed: () {
//              Navigator.pushNamed(context, "/cart_page");
//            },
//          ),
//        ),
//
//
//        FadeAnimation(2,
//          ClipRRect(
//            borderRadius: BorderRadius.all(Radius.circular(13)
//            ),
//            child: Container(
//              // height: 40,
//              // width: 40,
//              decoration: BoxDecoration(
//                color: Theme.of(context).backgroundColor,
//              ),
//              child: Image.asset("assets/images/user.png", fit: BoxFit.fill),
//            ),
//          ).p(8),
//        ),
//      ],
//    );
//  }
//
//  Widget header() {
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Text("Hello,", style: TextStyles.title.subTitleColor),
//        Text("$fullname", style: TextStyles.h1Style),
//      ],
//    ).p16;
//  }
//

//
//
//


//
//
//
//  Widget showCartButton() {
//    return InkWell(
//      onTap: () {
//        print("Button Register clicked");
//        if (_formKey.currentState.validate()) {
//          print("Validator Valid");
//          setState(() {
//            addToCart();
//          });
//        }
//      },
//      splashColor: Color.fromRGBO(143, 148, 251, 1),
//      child: Container(
//        height: 50,
//        decoration: BoxDecoration(
//            borderRadius: BorderRadius.circular(10),
//            gradient: LinearGradient(colors: [
//              Color.fromRGBO(143, 148, 251, 1),
//              Color.fromRGBO(143, 148, 251, .6),
//            ])),
//        child: Center(
//          child: Text(
//            "Add to Cart",
//            style: TextStyle(
//                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget scanButton() {
//    return Container(
//      height: 50.0,
//      width: 200,
//      child: RaisedButton(
//        child: Text(
//          "Scan Barcode",
//          style: TextStyle(
//            color: Colors.white,
//          ),
//        ),
//        color: Theme.of(context).accentColor,
//        onPressed: () {
//          startBarcodeScanStream();
//        },
//      ),
//    );
//  }
//
//  Widget appBarTitle() {
//    if (errorBarcode == true) {
//      return Container(
//        child: Center(
//          child: Text(
//            "Barcode belum terdaftar",
//            style: TextStyle(color: Colors.black),
//          ),
//        ),
//      );
//    } else {
//      return Text(
//        "$name",
//        style: TextStyle(color: Colors.black),
//      );
//    }
//  }
//
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_deltaprima_pos/animation/FadeAnimation.dart';
import 'package:flutter_deltaprima_pos/common_widget/icon_badge.dart';
import 'package:flutter_deltaprima_pos/constants/apis.dart';
import 'package:flutter_deltaprima_pos/localization/localization.dart';
import 'package:flutter_deltaprima_pos/main_page.dart';
import 'package:flutter_deltaprima_pos/src/cart/models/cart_list_model.dart';
import 'package:flutter_deltaprima_pos/src/cart/widget/cart_item.dart';
import 'package:flutter_deltaprima_pos/src/pos/services/add_cart_service.dart';
import 'package:flutter_deltaprima_pos/src/pos/services/get_label_count_service.dart';
import 'package:flutter_deltaprima_pos/src/pos/widget/custom_dialog_success_add_cart.dart';
import 'package:flutter_deltaprima_pos/src/products/models/products_model.dart';
import 'package:flutter_deltaprima_pos/src/products/services/get_products_service.dart';
import 'package:flutter_deltaprima_pos/src/shop/models/shop_list_model.dart';
import 'package:flutter_deltaprima_pos/style/light_color.dart';
import 'package:flutter_deltaprima_pos/style/text_styles.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_deltaprima_pos/style/extention.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';



class PosScanPage extends StatefulWidget {
  PosScanPage({Key key, this.model, this.item}) : super(key: key);
  final Shops model;
  final Cart item;

  @override
  _PosScanPageState createState() => new _PosScanPageState();
}

class _PosScanPageState extends State<PosScanPage> {

  TextEditingController controller = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();

  List<Cart> _searchResult = [];
  List<Cart> _userDetails = [];

  SharedPreferences prefs;

  LabelCountService labelCountService;
  GetProductService getProductService;
  AddCartService addCartService;

  final _formKey = GlobalKey<FormState>();

  bool errorBarcode;
  bool isBtnScan;
  bool isFav = false;

  String name;
  String images;
  String price;
  String productid;
  String takeBarcode = "";
  String barcode = "";
  String variant;
  String shopid;
  String labelcartcount;
  String fullname;
  String userid;




  @override
  void initState() {
    isBtnScan = true;
    getUserDetails();
    getPrefs();
    labelCountService = new LabelCountService();
    getProductService = new GetProductService();
    addCartService = new AddCartService();
    super.initState();

  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      print("Nama Substring, $userid");
      userid = prefs.getString('userid');
      shopid = prefs.getString('shopid');
      fullname = prefs.getString('fullname');
      getLabelCartCount();
    });
  }

  void getLabelCartCount() async {
    labelCountService.getLabelCount(Api.GET_LABEL_COUNT,
        {'user_id': userid, 'shop_id': shopid}).then((response) {
      if (response.error == false) {
        setState(() {
          labelcartcount = response.count.count;
          print("Total Cart $labelcartcount");
        });
      }
    });
  }

  Future<List<Cart>> getUserDetails() async {
    var res = await http.post(Uri.encodeFull(Api.GET_CART_LIST),
        headers: {"Accept": "application/json"},
        body: {'userid': '1', 'shopid': '1'});
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var rest = data["cart"] as List;
      print(res.body);
      _userDetails = rest.map<Cart>((j) => Cart.fromJson(j)).toList();
    }
    return _userDetails;
  }

  void getDetailProducts() async {
    getProductService.getProduct(Api.GET_PRODUCTS_DETAIL,
        {'shop_id': shopid, 'barcode': barcode}).then((response) {
      if (response.error == false) {
        setState(() {
          name = response.item.name;
          images = response.item.image;
          price = response.item.sellingPrice;
          productid = response.item.id;
          variant = response.item.variant;
          errorBarcode = false;
          isBtnScan = false;
          Navigator.pushNamed(context, 'detail_product');
        });
      } else if (response.error == true) {
        print("RESPONSE MESSAGES ${response.messages}");
        setState(() {
          errorBarcode = true;
        });
      }
    });
  }
  void addToCart() async {
    addCartService.insertCart(Api.INSERT_CART_URL, {
      'product_id': productid,
      'quantity': quantityController.text,
      'shop_id': shopid,
      'user_id': userid,
      'price': price,
      'status': 'onCart'
    }).then((response) {
      if (response.error == false) {
        setState(() {
          labelcartcount = labelcartcount;
          print("Sukses insert to Cart");
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (context) => new MainPage(currentTab: 0)),
          ).then((value) {
            setState(() {
              labelcartcount = labelcartcount;
            });
          });
          dialogSuccess(context);
        });
      }
    });
  }

  dialogSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CustomDialogSuccessAddCart(
          title: "Berhasil",
          description: "Produk sudah berhasil masuk di cart... Scan lagi ??",
          buttonPositiveText: "Tambah Barang",
          buttonNegativeText: "Lihat Cart",
          btnPositiveCallBack: () {
            Navigator.of(context).pop();
            startBarcodeScanStream();
          },
          btnNegativeCallback: () {
            Navigator.pushReplacementNamed(context, '/cart_page');
          }),
    );
  }

  startBarcodeScanStream() async {
    takeBarcode =
        await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true);
    setState(() {
      barcode = takeBarcode;
      print("Barcode $barcode");
      Vibration.vibrate(duration: 100);
      //getDetailProducts();
      Navigator.pushNamed(context, '/detail_product', arguments: widget.item);
      labelcartcount = labelcartcount;
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: myAppbar(),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          header(),
          searchField(),
          new Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? listViewSearchResults()
                : futureBuilder(),
          )
        ],
      ),

//      bottomNavigationBar: isBtnScan == true
//            ? Padding(
//                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 8, top: 8),
//                child: scanButtonNew(),
//              )
//            : Padding(
//                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 8, top: 8),
//                child: addCartButton(),
//      ),
    );
  }

  Widget scanButtonNew() {
    return InkWell(
      onTap: () {
        startBarcodeScanStream();
      },
      splashColor: Color.fromRGBO(143, 148, 251, 1),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(143, 148, 251, 1),
              Color.fromRGBO(143, 148, 251, .6),
            ])),
        child: Center(
          child: Text(
            AppLocalizations.of(context).translate('scan_button'),
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }


  Widget addCartButton() {
    return InkWell(
      onTap: () {
        print("Button Register clicked");
        if (_formKey.currentState.validate()) {
          print("Validator Valid");
          setState(() {
            addToCart();
          });
        }
      },
      splashColor: Color.fromRGBO(143, 148, 251, 1),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(143, 148, 251, 1),
              Color.fromRGBO(143, 148, 251, .6),
            ])),
        child: Center(
          child: Text(
            "Add to Cart",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget myAppbar() {
    return new AppBar(
      centerTitle: true,
      title: Text(
        "POS",
        style: TextStyle(color: Colors.black),
      ),
      elevation: 1,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(
        icon: Icon(
          Icons.short_text,
          size: 30,
          color: Colors.black,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      actions: <Widget>[
        FadeAnimation(
          1,
          IconButton(
            icon: IconBadge(
              icon: LineariconsFree.cart,
              size: 24.0,
              count: labelcartcount,
            ),
            color: LightColor.grey,
            onPressed: () {
              Navigator.pushNamed(context, "/cart_page");
            },
          ),
        ),
        FadeAnimation(
          2,
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            child: Container(
              // height: 40,
              // width: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              child: Image.asset("assets/images/user.png", fit: BoxFit.fill),
            ),
          ).p(8),
        ),
      ],
    );
  }

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hello,", style: TextStyles.title.subTitleColor),
        Text("FAJAR", style: TextStyles.h1Style),
      ],
    ).p16;
  }

  Widget searchField() {
    return Container(
      height: 55,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: LightColor.grey.withOpacity(.5),
            blurRadius: 10,
            offset: Offset(3, 3),
          )
        ],
      ),
      child: TextField(
        onChanged: onSearchTextChanged,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          hintText: "Search atau Scan Barcode",
          hintStyle: TextStyles.body.subTitleColor,
          suffixIcon: SizedBox(
              width: 50,
              child: Icon(FontAwesome5.barcode, color: LightColor.purple)
                  .alignCenter
                  .ripple(() {
                startBarcodeScanStream();
              }, borderRadius: BorderRadius.circular(13))),
        ),
      ),
    );
  }

  Widget barcodeKosong() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Center(
        child: Text("Silahkan Scan Barcode"),
      ),
    );
  }

  Widget barcodeBelumTerdaftar() {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Center(
        child: Text("Barcode belum terdaftar"),
      ),
    );
  }

  Widget formQuantity() {
    return TextFormField(
      validator: RequiredValidator(
          errorText:
              AppLocalizations.of(context).translate("error_form_entry")),
      controller: quantityController,
      autofocus: false,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
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
          hintText: AppLocalizations.of(context).translate("hint_quantity"),
          hintStyle: TextStyle(color: Colors.grey[400])),
    );
  }

  Widget futureBuilder() {
    return FutureBuilder(
        future: getUserDetails(),
        builder: (context, snapshot) {
          return snapshot.data != null
              ? buildListView(_userDetails)
              : Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: null,
                      strokeWidth: 1.5,
                    ),
                  ),
                );
        });
  }

  Widget buildListView(_userDetails) {
    return new ListView.builder(
      itemCount: _userDetails.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: CartItem(cart: _userDetails.elementAt(index)),
        );
      },
    );
  }

  Widget listViewSearchResults() {
    return new ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, i) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: CartItem(cart: _searchResult.elementAt(i)),
        );
      },
    );
  }



  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.name.contains(text) ||
          userDetail.sellingPrice.contains(text)) _searchResult.add(userDetail);
    });

    setState(() {});
  }
}
