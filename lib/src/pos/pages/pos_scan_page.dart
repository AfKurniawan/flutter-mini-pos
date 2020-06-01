import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_deltaprima_pos/animation/FadeAnimation.dart';
import 'package:flutter_deltaprima_pos/common_widget/icon_badge.dart';
import 'package:flutter_deltaprima_pos/constants/apis.dart';
import 'package:flutter_deltaprima_pos/localization/localization.dart';
import 'package:flutter_deltaprima_pos/src/pos/services/add_cart_service.dart';
import 'package:flutter_deltaprima_pos/src/pos/services/get_label_count_service.dart';
import 'package:flutter_deltaprima_pos/src/products/models/products_model.dart';
import 'package:flutter_deltaprima_pos/src/products/services/get_products_service.dart';
import 'package:flutter_deltaprima_pos/src/pos/widget/custom_dialog_success_add_cart.dart';
import 'package:flutter_deltaprima_pos/src/shop/models/shop_list_model.dart';
import 'package:flutter_deltaprima_pos/style/light_color.dart';
import 'package:flutter_deltaprima_pos/style/text_styles.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_deltaprima_pos/style/extention.dart';


class PosScanPage extends StatefulWidget {
  PosScanPage({Key key, this.model}) : super(key: key);
  final Shops model;

  @override
  _PosScanPageState createState() => _PosScanPageState();
}

class _PosScanPageState extends State<PosScanPage> {
  bool isFav = false;
  GetProductService getProductService;
  AddCartService addCartService;
  LabelCountService labelCountService;
  SharedPreferences prefs;
  bool isLogin;
  Shops model;
  Item item;
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
  bool isNotFound;
  String userid;
  bool isNotScanned;
  bool errorBarcode;
  bool isBtnScan;
  TextEditingController quantityController = new TextEditingController();
  TextEditingController receiveController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isBtnScan = true;
    model = widget.model;
    getProductService = new GetProductService();
    addCartService = new AddCartService();
    labelCountService = new LabelCountService();
    getPrefs();

  }


  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      print("Nama Substring, $userid");
      userid = prefs.getString('userid');
      shopid = prefs.getString('shopid');
      fullname = prefs.getString('fullname');
      getLabelCartCount();

      //startBarcodeScanStream();
    });
  }

  void getLabelCartCount() async {
    labelCountService.getLabelCount(Api.GET_LABEL_COUNT, {
      'user_id' : userid,
      'shop_id' : shopid
    }).then((response){
      if(response.error == false){
        setState(() {
          labelcartcount = response.count.count;
          print("Total Cart $labelcartcount");
        });
      }
    });
  }

  startBarcodeScanStream() async {
    takeBarcode =
        await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true);
    setState(() {
      barcode = takeBarcode;
      print("Barcode $barcode");
      Vibration.vibrate(duration: 100);
      getDetailProducts();
      labelcartcount = labelcartcount;
    });
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
    }).then((response){
      if(response.error == false){
        setState(() {
            labelcartcount = labelcartcount;
            print("Sukses insert to Cart");
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
        buttonPositiveText: "Scan Lagi",
        buttonNegativeText: "Lihat Cart",
        btnPositiveCallBack: (){
          Navigator.of(context).pop();
          startBarcodeScanStream();
        },
        btnNegativeCallback: (){
          Navigator.pushReplacementNamed(context, '/cart_page');
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: barcode == "" ? FadeAnimation(1,
          singleChildScrollView()
      )
       : detailProductWidget(),
      bottomNavigationBar:
          isBtnScan == true ?
      Padding(
        padding: const EdgeInsets.only(left:30, right: 30, bottom: 8),
        child: scanButtonNew(),
      )
              : Padding(
            padding: const EdgeInsets.only(left:30, right: 30, bottom: 8),
            child: showCartButton(),
          )
    );
  }

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hello,", style: TextStyles.title.subTitleColor),
        Text("$fullname", style: TextStyles.h1Style),
      ],
    ).p16;
  }

  Widget searchField() {
    return Container(
      height: 55,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: LightColor.grey.withOpacity(.5),
            blurRadius: 15,
            offset: Offset(5, 5),
          )
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          hintText: "Search atau Scan Barcode",
          hintStyle: TextStyles.body.subTitleColor,
          suffixIcon: SizedBox(
              width: 50,
              child: Icon(
                  FontAwesome5.barcode, color: LightColor.purple)
                  .alignCenter
                  .ripple(() {
                    startBarcodeScanStream();
              }, borderRadius: BorderRadius.circular(13))),
        ),
      ),
    );
  }

  Widget singleChildScrollView(){
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            header(),
            searchField(),
            //category(),
            barcodeKosong()
          ],
        ),
      ),
    );
  }

  Widget scanButtonNew(){
      return InkWell(
            onTap: (){
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
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
  }

  Widget showCartButton(){
    return InkWell(
      onTap: (){
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
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget scanButton(){
    return Container(
      height: 50.0,
      width: 200,
      child: RaisedButton(
        child: Text(
          "Scan Barcode",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        color: Theme.of(context).accentColor,
        onPressed: () {
          startBarcodeScanStream();
        },
      ),
    );
  }

  Widget appBarTitle(){
    if (errorBarcode == true) {
      return Container(
        child: Center(
          child: Text("Barcode belum terdaftar", style: TextStyle(color: Colors.black),),
        ),
      );
    } else {
      return Text("$name", style: TextStyle(color: Colors.black),);
    }
  }

  Widget myAppbar(){
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: LightColor.grey,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: barcode == "" ? barcodeKosong() : appBarTitle(),
      elevation: 0.5,
      actions: <Widget>[
        IconButton(
          icon: IconBadge(
            icon: Icons.shopping_cart,
            size: 26.0,
            count: labelcartcount,
          ),
          color: LightColor.grey,
          onPressed: () {
            Navigator.pushNamed(context, "/cart_page");
          },
        ),
      ],
    );
  }

  Widget barcodeKosong(){
    return Container(
      height: MediaQuery.of(context).size.height /2,
      child: Center(
        child: Text("Silahkan Scan Barcode"),
      ),
    );
  }

  Widget barcodeBelumTerdaftar(){
    return Container(
      height: MediaQuery.of(context).size.height /2,
      child: Center(
        child: Text("Barcode belum terdaftar"),
      ),
    );
  }

  Widget barcodeUnregistered(){
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            header(),
            searchField(),
            //category(),
            barcodeBelumTerdaftar()
          ],
        ),
      ),
    );
  }

  Widget detailProductWidget() {
    if (errorBarcode == true) {
      return barcodeUnregistered();
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 3.2,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: images == null
                      ? Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 3.2,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ))
                      : Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 3.2,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        "${Api.PRODUCTS_IMAGES_URL}$images",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -10.0,
                  bottom: 3.0,
                  child: RawMaterialButton(
                    onPressed: () {},
                    fillColor: Colors.white,
                    shape: CircleBorder(),
                    elevation: 4.0,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 17,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                name == null ?
                Text(
                  "",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                ) :
                Text(
                  "$name",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                ),
                SizedBox(width: 5),
                variant == null ?
                Text(
                  "",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                ) :
                Text(
                  "$variant",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
              child: Row(
                children: <Widget>[
                  price == null ?
                  Text(
                    "",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                      color: Theme
                          .of(context)
                          .accentColor,
                    ),
                  ) :
                  Text(
                    "Rp. $price",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                      color: Theme
                          .of(context)
                          .accentColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Quantity",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),

            SizedBox(height: 10),

            Form(
                key: _formKey,
                child: formReceiveAmount()
            ),

            SizedBox(height: 20.0),
          ],
        ),
      );
    }
  }

  Widget formReceiveAmount(){
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
          hintText: AppLocalizations.of(context)
              .translate("hint_quantity"),
          hintStyle: TextStyle(color: Colors.grey[400])),
    );
  }

}
