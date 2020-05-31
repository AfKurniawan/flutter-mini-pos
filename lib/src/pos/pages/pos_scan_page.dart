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
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';


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
  bool isNotFound;
  String userid;
  bool isNotScanned;
  bool errorBarcode;
  TextEditingController quantityController = new TextEditingController();
  TextEditingController receiveController = new TextEditingController();

  @override
  void initState() {
    super.initState();
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
      getLabelCartCount();
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
            print("Sukses insert to Cart");
            dialogSuccess(context);
        });
      }
    });
  }


  void handleSubmitted(String value) {
   setState(() {
     //dialogSuccess(context);
     addToCart();
     getLabelCartCount();
     print("TEXT FORM FIELD HANDLE");
   });
  }

  void showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to cart'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  dialogSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialogSuccessAddCart(
        title: "Berhasil",
        description: "Produk sudah berhasil masuk di cart... Scan lagi ??",
        buttonPositiveText: "Scan Lagi",
        buttonNegativeText: "Lihat Cart",
        btnPositiveCallBack: (){
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
      //appBar: myAppbar(),
      body: barcode == "" ? barcodeKosong()
       : body(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left:18.0, right: 18, bottom: 10),
        child: scanButtonNew(),
      ),
    );
  }

  Widget scanButtonNew(){

      return  FadeAnimation(
          2,
          InkWell(
            onTap: (){
              startBarcodeScanStream();
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
                  AppLocalizations.of(context).translate('scan_button'),
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
      child: Center(
        child: Text("Silahkan Scan Barcode"),
      ),
    );
  }



  Widget body() {
    if (errorBarcode == true) {
      return Container(
        child: Center(
          child: Text("Barcode belum terdaftar"),
        ),
      );
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
                  child: images == ""
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
                Text(
                  "$name",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                ),
                SizedBox(width: 5),
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

            TextFormField(
              controller: quantityController,
              onFieldSubmitted: handleSubmitted,
              autofocus: true,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              validator: RequiredValidator(
                  errorText:
                  AppLocalizations.of(context).translate("error_form_entry")),
              //controller: controllerShopAddress,
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
            ),

            SizedBox(height: 20.0),
          ],
        ),
      );
    }
  }


}
