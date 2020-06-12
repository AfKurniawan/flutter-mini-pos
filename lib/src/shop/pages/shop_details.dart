import 'package:flutter/material.dart';
import 'package:flutter_mini_pos/constants/apis.dart';
import 'package:flutter_mini_pos/src/shop/models/shop_list_model.dart';
import 'package:flutter_mini_pos/src/shop/widget/custom_float.dart';
import 'package:flutter_mini_pos/src/shop/widget/grid_product.dart';
import 'package:flutter_mini_pos/src/shop/widget/shop_item_widget.dart';
import 'package:flutter_mini_pos/style/light_color.dart';
import 'package:flutter_mini_pos/style/text_styles.dart';
import 'package:flutter_mini_pos/style/theme.dart';
import 'package:flutter_mini_pos/style/extention.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ShopDetailPage extends StatefulWidget {
  ShopDetailPage({Key key, this.model}) : super(key: key);
  final Shops model;

  @override
  _ShopDetailPageState createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  Shops model;
  List<Shops> shoplist;
  String shopid;
  SharedPreferences prefs;


  @override
  void initState() {
    model = widget.model;
    super.initState();
    shopid = widget.model.id;
  }


  Future<List<Shops>> getShopList() async {
    var res = await http.post(Uri.encodeFull(Api.GET_SHOP_LIST),
        headers: {"Accept": "application/json"}, body: {'userid': '1'});
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var rest = data["shops"] as List;
      print(res.body);
      shoplist = rest.map<Shops>((j) => Shops.fromJson(j)).toList();

    }
    return shoplist;

  }

  Widget _appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        BackButton(color: Theme.of(context).primaryColor),
//        IconButton(
//            icon: Icon(
//              model.isfavourite ? Icons.favorite : Icons.favorite_border,
//              color: model.isfavourite ? Colors.red : LightColor.grey,
//            ),
//            onPressed: () {
//              setState(() {
//                model.isfavourite = !model.isfavourite;
//              });
//            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 25).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 23).bold;
    }

    return Scaffold(

      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),
        child: ListView(
          children: <Widget>[

            SizedBox(height: 10.0),

            Text(
              "Products Categories",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.0),

//            Container(
//              height: 65.0,
//              child: ListView.builder(
//                scrollDirection: Axis.horizontal,
//                shrinkWrap: true,
//                itemCount: categories == null ? 0 :categories.length,
//                itemBuilder: (BuildContext context, int index) {
//                  Map cat = categories[index];
//                  return HomeCategory(
//                    icon: cat['icon'],
//                    title: cat['name'],
//                    items: cat['items'].toString(),
//                    isHome: true,
//                  );
//                },
//              ),
//            ),

            SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Products",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                FlatButton(
                  child: Text(
                    "View More",
                    style: TextStyle(
//                      fontSize: 22,
//                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: (){},
                ),
              ],
            ),
            SizedBox(height: 10.0),

            futureBuilder(),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget futureBuilder() {
    return FutureBuilder(
        future: getShopList(),
        builder: (context, snapshot) {
          return snapshot.data != null
              //? buildListView(snapshot.data)
          ? gridViewBuilder(snapshot.data)
              : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: const CircularProgressIndicator(
                      value: null,
                      strokeWidth: 1.0,
                    )),
              ],
            ),
          );
        });
  }

  Widget gridViewBuilder(List<Shops> list){
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.25),
      ),
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (BuildContext context, int index) {
//                Food food = Food.fromJson(foods[index]);
        return GridProduct(shops: list.elementAt(index));
      },
    );
  }

  Widget buildListView(List<Shops> list) {
    return new ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      itemCount: list == null
          ? Center(
        child: CircularProgressIndicator(
          value: null,
          strokeWidth: 1.0,
        ),
      )
          : list.length,
      itemBuilder: (context, index) {
        return ShopItemWidget(shops: list.elementAt(index));
      },
    );
  }

  Widget myBottomBar(){
    return BottomAppBar(
      clipBehavior: Clip.antiAlias,
      shape: CircularNotchedRectangle(),
      child: Ink(
        height: 50,
        decoration: new BoxDecoration(
            gradient: new LinearGradient(colors: AppTheme.kitGradients)
        ),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {},
              child: Container(
                height: 50,
                width: 150,
                child: Icon(Icons.person_outline, color: Colors.white),
              ),
            ),
            new SizedBox(
              width: 20.0,
            ),
            InkWell(
              onTap: () {},
              child: Container(
                height: 50,
                width: 150,
                child: Icon(Icons.shopping_cart, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
