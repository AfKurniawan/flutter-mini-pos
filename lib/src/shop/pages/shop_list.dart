import 'package:flutter/material.dart';
import 'package:flutter_deltaprima_pos/constants/apis.dart';
import 'package:flutter_deltaprima_pos/src/shop/models/shop_list_model.dart';
import 'package:flutter_deltaprima_pos/src/shop/services/get_shop_list_service.dart';
import 'package:flutter_deltaprima_pos/src/shop/widget/shop_item_widget.dart';
import 'package:flutter_deltaprima_pos/style/light_color.dart';
import 'package:flutter_deltaprima_pos/style/text_styles.dart';
import 'package:flutter_deltaprima_pos/style/extention.dart';
import 'package:flutter_deltaprima_pos/style/theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ShopListPage extends StatefulWidget {
  @override
  _ShopListPageState createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  SharedPreferences prefs;
  GetShopListService shopListService;

  String userid;
  String fullName;

  List<Shops> shoplist;

  @override
  void initState() {
    super.initState();
    shopListService = new GetShopListService();
    getPrefs();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid");
      fullName = prefs.getString("fullname");
      print("UserID di halaman ShopListPage $userid");
      print("FullName di halaman ShopListPage $fullName");
      getShopList();
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Theme.of(context).backgroundColor,

      body: singleChildScrollView()
      //body: customScrollView(),
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
              category(),
              newShopList(),
              futureBuilder()
            ],
          ),
        ),
      );
  }

  Widget customScrollView(){
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              header(),
              searchField(),
              category(),
              //futureBuilder()
            ],
          ),
        ),
        shopList()
      ],
    );
  }

  Widget newShopList(){
    return Padding(
      padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Top Kamu", style: TextStyles.title.bold),
          IconButton(
              icon: Icon(
                Icons.sort,
                color: Color.fromRGBO(143, 148, 251, 1),
              ),
              onPressed: () {})
        ],
      ),
    );
  }

  Widget shopList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Top Doctors", style: TextStyles.title.bold),
              IconButton(
                  icon: Icon(
                    Icons.sort,
                    color: Color.fromRGBO(143, 148, 251, 1),
                  ),
                  onPressed: () {})
            ],
          ).hP16,
          Center(child: futureBuilder())
        ],
      ),
    );
  }

  Widget futureBuilder() {
    return FutureBuilder(
        future: getShopList(),
        builder: (context, snapshot) {
          return snapshot.data != null
              ? buildListView(snapshot.data)
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

  Widget appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: Icon(
        Icons.short_text,
        size: 30,
        color: Colors.black,
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
            child: Image.asset("assets/user.png", fit: BoxFit.fill),
          ),
        ).p(8),
      ],
    );
  }

  Widget header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hello,", style: TextStyles.title.subTitleColor),
        Text("Peter Parker", style: TextStyles.h1Style),
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
        borderRadius: BorderRadius.all(Radius.circular(13)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: LightColor.grey.withOpacity(.3),
            blurRadius: 15,
            offset: Offset(5, 5),
          )
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          hintText: "Search",
          hintStyle: TextStyles.body.subTitleColor,
          suffixIcon: SizedBox(
              width: 50,
              child: Icon(Icons.search, color: LightColor.purple)
                  .alignCenter
                  .ripple(() {}, borderRadius: BorderRadius.circular(13))),
        ),
      ),
    );
  }

  Widget category() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Toko Kamu", style: TextStyles.title.bold),
              Text(
                "See All",
                style: TextStyles.titleNormal
                    .copyWith(color: LightColor.purple),
              ).p(8).ripple(() {})
            ],
          ),
        ),
        SizedBox(
          height: AppTheme.fullHeight(context) * .28,
          width: AppTheme.fullWidth(context),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              categoryCard("Chemist & Drugist", "350 + Stores",
                  color: LightColor.green, lightColor: LightColor.lightGreen),
              categoryCard("Covid - 19 Specilist", "899 Doctors",
                  color: LightColor.skyBlue, lightColor: LightColor.lightBlue),
              categoryCard("Cardiologists Specilist", "500 + Doctors",
                  color: LightColor.orange, lightColor: LightColor.lightOrange)
            ],
          ),
        ),


      ],
    );
  }

  Widget categoryCard(String title, String subtitle,
      {Color color, Color lightColor}) {
    TextStyle titleStyle = TextStyles.title.bold.white;
    TextStyle subtitleStyle = TextStyles.body.bold.white;
    if (AppTheme.fullWidth(context) < 392) {
      titleStyle = TextStyles.body.bold.white;
      subtitleStyle = TextStyles.bodySm.bold.white;
    }
    return AspectRatio(
      aspectRatio: 6 / 8,
      child: Container(
        height: 280,
        width: AppTheme.fullWidth(context) * .3,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 10,
              color: lightColor.withOpacity(.8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -20,
                  left: -20,
                  child: CircleAvatar(
                    backgroundColor: lightColor,
                    radius: 60,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      child: Text(title, style: titleStyle).hP8,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Flexible(
                      child: Text(
                        subtitle,
                        style: subtitleStyle,
                      ).hP8,
                    ),
                  ],
                ).p16
              ],
            ),
          ),
        ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
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
}
