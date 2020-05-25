import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_deltaprima_pos/common_widget/icon_badge.dart';
import 'package:flutter_deltaprima_pos/constants/apis.dart';
import 'package:flutter_deltaprima_pos/src/products/models/products.dart';
import 'package:flutter_deltaprima_pos/src/products/services/get_products_service.dart';
import 'package:flutter_deltaprima_pos/src/shop/models/shop_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          isNotFound = false;
        });
      } else if (response.error == true) {
        print("RESPONSE MESSAGES ${response.messages}");
        setState(() {
          isNotFound = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: isNotFound == true ? Text("Product Not Found")
        : Text(
          "$name, ${model.id}, $userid",
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: IconBadge(
              icon: Icons.shopping_cart,
              size: 26.0,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: barcode == ""
          ? Container(
              child: Center(
              child: CircularProgressIndicator(),
            ))
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

  Widget body() {
    if (isNotFound == true) {
      return Container(
        child: Center(
          child: Text("Product Not Found"),
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
              "Product Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            SizedBox(height: 10.0),
            Text(
              "Nulla quis lorem ut libero malesuada feugiat. Lorem ipsum dolor "
                  "sit amet, consectetur adipiscing elit. Curabitur aliquet quam "
                  "id dui posuere blandit. Pellentesque in ipsum id orci porta "
                  "dapibus. Vestibulum ante ipsum primis in faucibus orci luctus "
                  "et ultrices posuere cubilia Curae; Donec velit neque, auctor "
                  "sit amet aliquam vel, ullamcorper sit amet ligula. Donec"
                  " rutrum congue leo eget malesuada. Vivamus magna justo,"
                  " lacinia eget consectetur sed, convallis at tellus."
                  " Vivamus suscipit tortor eget felis porttitor volutpat."
                  " Donec rutrum congue leo eget malesuada."
                  " Pellentesque in ipsum id orci porta dapibus.",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
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
            SizedBox(height: 20.0),
          ],
        ),
      );
    }
  }

}
