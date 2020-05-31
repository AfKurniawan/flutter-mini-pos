import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_deltaprima_pos/constants/apis.dart';
import 'package:flutter_deltaprima_pos/src/cart/models/cart_list_model.dart';
import 'package:flutter_deltaprima_pos/src/cart/services/delete_cart_service.dart';
import 'package:flutter_deltaprima_pos/src/cart/services/total_cart_service.dart';
import 'package:flutter_deltaprima_pos/src/cart/widget/cart_item.dart';
import 'package:flutter_deltaprima_pos/style/light_color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_deltaprima_pos/style/extention.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CartListPage extends StatefulWidget {
  VoidCallback deleteCart;

  CartListPage({this.deleteCart});

  @override
  _CartListPageState createState() => _CartListPageState();
}

class _CartListPageState extends State<CartListPage> {
  final TextEditingController _couponlControl = new TextEditingController();
  SharedPreferences prefs;
  List<Cart> cartlist;
  String userid;
  String fullname;
  String shopid;
  String cartid;
  String totalcart = "";
  TotalCartService totalCartService;
  DeleteCartService deleteCartService;

  @override
  void initState() {
    super.initState();
    totalCartService = new TotalCartService();
    deleteCartService = new DeleteCartService();
    getPrefs();
    //getTotalCart();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid");
      shopid = prefs.getString('shopid');
      fullname = prefs.getString("fullname");
      print("UserID di halaman CartListPage $userid");
      print("ShopID di halaman CartListPage $shopid");
      //getCartList();
      getTotalCart();
    });
  }

  Future<List<Cart>> getCartList() async {
    var res = await http.post(Uri.encodeFull(Api.GET_CART_LIST),
        headers: {"Accept": "application/json"},
        body: {'userid': userid, 'shopid': shopid});
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var rest = data["cart"] as List;
      print(res.body);
      cartlist = rest.map<Cart>((j) => Cart.fromJson(j)).toList();
    }
    return cartlist;
  }

  void getTotalCart() async {
    totalCartService.getTotalCart(
        Api.GET_TOTAL_CART, {'user_id': '11', 'shop_id': '1'}).then((response) {
      if (response.error == false) {
        setState(() {
          totalcart = response.totals.total;
          print("Total Cart $totalcart");
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 140),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Text(
              "Payment Method",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            Card(
              elevation: 4.0,
              child: ListTile(
                title: Text("John Doe"),
                subtitle: Text(
                  "5506 7744 8610 9638",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                leading: Icon(
                  FontAwesomeIcons.creditCard,
                  size: 50.0,
                  color: Colors.deepPurple,
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Items",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10.0),
            futureBuilder(),
          ],
        ),
      ),
      bottomSheet: Card(
        elevation: 8.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.grey[100],
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[100],
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Receive Amount",
                      prefixIcon: Icon(
                        FontAwesomeIcons.moneyCheck,
                        color: LightColor.grey,
                      ),
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: LightColor.grey,
                      ),
                    ),
                    maxLines: 1,
                    controller: _couponlControl,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        totalcart == ""
                            ? Text(
                                "Menghitung",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).accentColor,
                                ),
                              )
                            : Text(
                                "Rp.$totalcart",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                        Text(
                          "Delivery charges included",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                    width: 150.0,
                    height: 50.0,
                    child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        "Place Order".toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
          height: 130,
        ),
      ),
    );
  }

  Widget appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        "Checkout",
        style: TextStyle(color: Colors.black),
      ),
      elevation: .5,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: LightColor.grey,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        Icon(
          Icons.notifications_none,
          size: 30,
          color: LightColor.grey,
        ),
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
      ],
    );
  }

  Widget futureBuilder() {
    return FutureBuilder(
        future: getCartList(),
        builder: (context, snapshot) {
          return snapshot.data != null
              ? buildListView(snapshot.data)
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

  Widget buildListView(List<Cart> list) {

    return new ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, index) {
        return CartItem(cart: list.elementAt(index));
//        return Container(
//          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              list[index].image == ""
//                  ? ClipRRect(
//                      borderRadius: BorderRadius.all(Radius.circular(13)),
//                      child: Container(
//                        height: 55,
//                        width: 55,
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(15),
//                          color: randomColor(),
//                        ),
//                      ),
//                    )
//                  : Container(
//                      child: Container(
//                        height: 70,
//                        width: 70,
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.all(Radius.circular(5)),
//                          image: DecorationImage(
//                              image: NetworkImage(
//                                  Api.PRODUCTS_IMAGES_URL + list[index].image),
//                              fit: BoxFit.cover),
//                        ),
//                      ),
//                    ),
//              SizedBox(width: 15),
//              Flexible(
//                child: Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Expanded(
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Divider(),
//                          Text(list[index].name,
//                              overflow: TextOverflow.ellipsis,
//                              maxLines: 2,
//                              style: TextStyle(
//                                  fontSize: 16,
//                                  fontWeight: FontWeight.w900,
//                                  color: Colors.blueGrey)),
//
//                          Text(list[index].cartId,
//                              overflow: TextOverflow.ellipsis,
//                              maxLines: 2,
//                              style: TextStyle(
//                                  fontSize: 10,
//                                  fontWeight: FontWeight.w900,
//                                  color: Colors.blueGrey)),
//
//                          SizedBox(height: 3.0),
//                          Text(
//                            "Rp. ${list[index].sellingPrice}",
//                            style: TextStyle(
//                              fontSize: 14.0,
//                              fontWeight: FontWeight.w900,
//                              color: LightColor.skyBlue,
//                            ),
//                          ),
//                          SizedBox(height: 3),
//                          Text(
//                            "Qty: ${list[index].quantity}",
//                            style: TextStyle(
//                              fontSize: 13.0,
//                              color: LightColor.purpleLight,
//                              fontWeight: FontWeight.w500,
//                            ),
//                          ),
//                          SizedBox(height: 3),
//                          Row(
//                            children: <Widget>[
//                              Text(
//                                "SubTotal",
//                                style: TextStyle(
//                                  fontSize: 14.0,
//                                  fontWeight: FontWeight.w500,
//                                  color: LightColor.lightOrange,
//                                ),
//                              ),
//                              SizedBox(width: 3),
//                              Text(
//                                "Rp. ${list[index].total}",
//                                style: TextStyle(
//                                  fontSize: 14.0,
//                                  fontWeight: FontWeight.w500,
//                                  color: Colors.deepOrange,
//                                ),
//                              ),
//                            ],
//                          ),
//                          Divider(),
//                        ],
//                      ),
//                    ),
//                    SizedBox(width: 8),
//                    Column(
//                      crossAxisAlignment: CrossAxisAlignment.end,
//                      children: <Widget>[
//                        IconButton(
//                          onPressed: () {
//                            setState(() {
//                             // cartid = list[index].id;
//                              print("CARRRRT IDDDD ${list[index].cartId}");
//                              print("IKI opo $index");
//                              list.removeAt(index);
//                              updateCartState(list[index].cartId);
//                            });
//                          },
//                          iconSize: 30,
//                          padding: EdgeInsets.symmetric(horizontal: 5),
//                          icon: Icon(Icons.delete_outline),
//                          color: Theme.of(context).hintColor,
//                        ),
//                      ],
//                    ),
//                  ],
//                ),
//              )
//            ],
//          ),
//        );
      },
    );
  }

  Color randomColor() {
    var random = Random();
    final colorList = [
      Theme.of(context).primaryColor,
      LightColor.orange,
      LightColor.green,
      LightColor.grey,
      LightColor.lightOrange,
      LightColor.skyBlue,
      LightColor.titleTextColor,
      Colors.red,
      Colors.brown,
      LightColor.purpleExtraLight,
      LightColor.skyBlue,
    ];
    var color = colorList[random.nextInt(colorList.length)];
    return color;
  }
}
