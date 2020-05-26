import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_deltaprima_pos/common_widget/icon_badge.dart';
import 'package:flutter_deltaprima_pos/constants/apis.dart';
import 'package:flutter_deltaprima_pos/localization/localization.dart';
import 'package:flutter_deltaprima_pos/src/products/models/products.dart';
import 'package:flutter_deltaprima_pos/src/products/services/get_products_service.dart';
import 'package:flutter_deltaprima_pos/src/products/widget/custom_dialog_success_add_cart.dart';
import 'package:flutter_deltaprima_pos/src/shop/models/shop_list_model.dart';
import 'package:flutter_deltaprima_pos/style/light_color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';


class ProductDetails extends StatefulWidget {
  ProductDetails({Key key, this.model}) : super(key: key);
  final Shops model;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isFav = false;
  GetProductService getProductService;
  SharedPreferences prefs;
  bool isLogin;
  Shops model;
  Item item;
  String name;
  String images;
  String price;
  String takeBarcode = "";
  String barcode = "";
  String variant;
  bool isNotFound;
  String userid;
  bool isNotScanned;
  bool errorBarcode;

  @override
  void initState() {
    super.initState();
    model = widget.model;
    getProductService = new GetProductService();
    getPrefs();

  }


  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('shopid', model.id);
      print("Nama Substring, $userid");
      userid = prefs.getString('userid');
      startBarcodeScanStream();
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
    });
  }

  void getDetailProducts() async {
    getProductService.getProduct(Api.GET_PRODUCTS_DETAIL,
        {'shop_id': model.id, 'barcode': barcode}).then((response) {
      if (response.error == false) {
        setState(() {
          name = response.item.name;
          images = response.item.image;
          price = response.item.sellingPrice;
          variant = response.item.variant;
          errorBarcode = false;
        });
      } else if (response.error == true) {
        print("RESPONSE MESSAGES ${response.messages}");
        setState(() {
          //isNotFound = true;
          errorBarcode = true;

        });
      }
    });
  }

  void showSnackbar(){
    Fluttertoast.showToast(
        msg: "Product sudah dimasukkan ke Cart",
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0
    );

    startBarcodeScanStream();
  }

  void handleSubmitted(String value) {
   setState(() {
     dialogSuccess(context);
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
        description: "Produk sudah berhasil masuk di cart",
        buttonPositiveText: AppLocalizations.of(context)
            .translate("button_register_dialog_success"),
        buttonNegativeText: AppLocalizations.of(context).translate("button_negative_success"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            ),
            color: LightColor.grey,
            onPressed: () {
              Navigator.pushNamed(context, "/cart_page");
            },
          ),
        ],
      ),
      body: barcode == "" ? barcodeKosong()
       : body(),
      bottomNavigationBar: Container(
        height: 50.0,
        child: RaisedButton(
          child: Text(
            "Scan Again",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          color: Theme.of(context).accentColor,
          onPressed: () {
            startBarcodeScanStream();
          },
        ),
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
