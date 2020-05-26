import 'package:flutter/material.dart';
import 'package:flutter_deltaprima_pos/constants/apis.dart';
import 'package:flutter_deltaprima_pos/src/cart/models/cart.dart';
import 'package:flutter_deltaprima_pos/src/cart/widget/cart_item.dart';
import 'package:flutter_deltaprima_pos/style/light_color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_deltaprima_pos/style/extention.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _couponlControl = new TextEditingController();
  SharedPreferences prefs;
  List<Cart> cartlist;
  String userid;
  String fullname;
  String shopid;

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid");
      shopid = prefs.get('shopid');
      fullname = prefs.getString("fullname");
      print("UserID di halaman CartListPage $userid");
      print("ShopID di halaman CartListPage $shopid");
      //getCartList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 130),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            ListTile(
              title: Text(
                "John Doe",
                style: TextStyle(
//                    fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              subtitle: Text("1278 Loving Acres Road Kansas City, MO 64110"),
            ),
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
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.grey[100],
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey[100],
                        ),
                        borderRadius: BorderRadius.circular(5.0),
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
                        Text(
                          r"$ 212",
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
                height: MediaQuery.of(context).size.height /2,
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
      },
    );
  }
}
