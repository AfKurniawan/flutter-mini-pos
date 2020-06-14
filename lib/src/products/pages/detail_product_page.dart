import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_mini_pos/animation/FadeAnimation.dart';
import 'package:flutter_mini_pos/common_widget/form_field_widget.dart';
import 'package:flutter_mini_pos/common_widget/icon_badge.dart';
import 'package:flutter_mini_pos/constants/apis.dart';
import 'package:flutter_mini_pos/localization/localization.dart';
import 'package:flutter_mini_pos/src/pos/services/add_cart_service.dart';
import 'package:flutter_mini_pos/src/pos/services/get_label_count_service.dart';
import 'package:flutter_mini_pos/src/pos/widget/custom_dialog_success_add_cart.dart';
import 'package:flutter_mini_pos/src/products/models/products_model.dart';
import 'package:flutter_mini_pos/src/products/services/get_products_service.dart';
import 'package:flutter_mini_pos/src/shop/models/shop_list_model.dart';
import 'package:flutter_mini_pos/style/light_color.dart';
import 'package:flutter_mini_pos/style/text_styles.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_mini_pos/style/extention.dart';

class DetailProductPage extends StatefulWidget {

  DetailProductPage({Key key, this.item}) : super(key: key);
  final Item item;

  @override
  _DetailProductPageState createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
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
    item = widget.item;
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
          },
          btnNegativeCallback: (){
            Navigator.pushReplacementNamed(context, 'cart_page');
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppbar(),
        body: item.barcode == "" ? FadeAnimation(1,
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
          child: addCartButton(),
        )
    );
  }

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hello,", style: TextStyles.title.subTitleColor),
        Text("$fullname", style: TextStyles.h1Style),
        Text("${item.name}"),
      ],
    ).p16;
  }

  Widget singleChildScrollView(){
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            header(),

          ],
        ),
      ),
    );
  }

  Widget scanButtonNew(){
    return InkWell(
      onTap: (){

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

  Widget addCartButton(){
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
            //category(),
            barcodeBelumTerdaftar()
          ],
        ),
      ),
    );
  }

  Widget detailProductWidget() {
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
                  child: item.image == null
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
                        "${Api.PRODUCTS_IMAGES_URL}${item.image}",
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
                item.name == null ?
                Text(
                  "",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                ) :
                Text(
                  "${item.name}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 2,
                ),
                SizedBox(width: 5),
                item.variant == null ?
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
                  "${item.variant}",
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
                  item.sellingPrice == null ?
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
                    "Rp. ${item.sellingPrice}",
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
                //child: formQuantity()
              child: FormFieldWidget(
                hint: AppLocalizations.of(context)
                    .translate("hint_quantity"),
              ),
            ),

            SizedBox(height: 20.0),
          ],
        ),
      );

  }

}
