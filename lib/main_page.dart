import 'dart:async';
import 'package:flashy_tab_bar/flashy_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mini_pos/animation/FadeAnimation.dart';
import 'package:flutter_mini_pos/common_widget/drawer_widget.dart';
import 'package:flutter_mini_pos/common_widget/icon_badge.dart';
import 'package:flutter_mini_pos/constants/apis.dart';
import 'package:flutter_mini_pos/src/cart/pages/cart_list_page.dart';
import 'package:flutter_mini_pos/src/home/pages/home_page.dart';
import 'package:flutter_mini_pos/src/products/pages/product_list_page.dart';
import 'package:flutter_mini_pos/src/pos/services/get_label_count_service.dart';
import 'package:flutter_mini_pos/src/register/pages/register_page.dart';
import 'package:flutter_mini_pos/src/shop/pages/create_shop.dart';
import 'package:flutter_mini_pos/src/shop/pages/shop_home.dart';
import 'package:flutter_mini_pos/src/shop/pages/shop_list.dart';
import 'package:flutter_mini_pos/src/shop/widget/custom_float.dart';
import 'package:flutter_mini_pos/style/light_color.dart';
import 'package:flutter_mini_pos/style/extention.dart';
import 'package:flutter_mini_pos/style/theme.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {

  int currentTab;
  String currentTitle;
  Widget currenPage = new ShopListPage();

  MainPage({Key key, this.currentTab}){
    currentTab = currentTab != null ? currentTab : 1 ;
  }



  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  SharedPreferences prefs;
  LabelCountService labelCountService;
  String userid;
  String shopid;
  String usertype;
  String labelcartcount = "";
  bool stoptimer;
  Timer timer;

  @override
  void initState() {
    startTimer();
    getPrefs();
    labelCountService = new LabelCountService();
    selectTab(widget.currentTab);
    stoptimer = false;
    super.initState();
  }

  getPrefs() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString('userid');
      shopid = prefs.getString('shopid');
      usertype = prefs.getString('usertype');
      getLabelCartCount();
    });

  }

  startTimer() {
   timer = Timer.periodic(Duration(seconds: 1), (_) {

     if(mounted){
       print("TIMER START RUNNING");
       getLabelCartCount();
     } else {
       return;
     }

    });
  }

  getLabelCartCount() async {
    print("Get Label Cart count Start");
    labelCountService.getLabelCount(Api.GET_LABEL_COUNT, {
      'user_id' : userid,
      'shop_id' : shopid
    }).then((response){
      if(response.error == false){
        setState(() {
          labelcartcount = response.count.count;
          print("Total Cart MAIN PAGE $labelcartcount");
          timer?.cancel();
          timer = null;
        });
      }
    });
  }

  @override
  void didUpdateWidget(MainPage oldWidget){
    selectTab(oldWidget.currentTab);
  }

  void selectTab(int tabItem){
    setState(() {
      widget.currentTab = tabItem;
      switch (tabItem) {
        case 0 :
          widget.currentTitle = "POS";
          widget.currenPage = ProductListPage();
          getLabelCartCount();
          //startTimer();
          break;

        case 1 :
          widget.currentTitle = "Beranda";
          widget.currenPage = Homepage();
          getLabelCartCount();
          //startTimer();
          break;

        case 2 :
          widget.currentTitle = "Account";
          widget.currenPage = Homepage();
         getLabelCartCount();
          //startTimer();

      }

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawerMenu(),
        //appBar: myAppBar(),
      body: widget.currenPage,
      bottomNavigationBar: flashyTabBar(),
    );
  }



  Widget myAppBar(){
    return new AppBar(
      centerTitle: true,
      title: Text(widget.currentTitle,
        style: TextStyle(color: Colors.black),
      ),
      elevation: 1,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(
        icon: Icon(Icons.short_text,
        size: 30,
        color: Colors.black,
        ),
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
      ),
      actions: <Widget>[
        FadeAnimation(1,
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
//        SizedBox(width: 2),
//        FadeAnimation(2,
//          Icon(
//            LineariconsFree.history,
//            size: 20,
//            color: LightColor.grey,
//          ),
//        ),

        FadeAnimation(2,
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(13)
            ),
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

  Widget flashyTabBar(){
    return FlashyTabBar(
      selectedIndex: widget.currentTab,
      showElevation: true,
      onItemSelected: (index) => setState(() {
        selectTab(index);
      }),
      items: [
        FlashyTabBarItem(
          icon:Icon(LineariconsFree.store,
          size: 20,
          ),
          title: Text(widget.currentTitle),
        ),
        FlashyTabBarItem(
          icon:Icon(LineariconsFree.home,
          size: 20,
          ),
          title: Text(widget.currentTitle),
        ),
        FlashyTabBarItem(
          icon:Icon(LineariconsFree.chart_bars,
            size: 20,
          ),
          title: Text(widget.currentTitle),
        ),
      ],
    );
  }

  Widget drawerMenu(){
    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.1),
//              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
              ),


              accountName: Text(
                "Fajar",
                style: Theme.of(context).textTheme.title,
              ),
              accountEmail: Text(
                "1234567880",
                style: Theme.of(context).textTheme.caption,
              ),

              currentAccountPicture:  ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(13)
                ),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: Image.asset("assets/images/user.png", fit: BoxFit.fill),
                ),
              ).p(8),
            ),
          ),

          ListTile(
            onTap: () {
            },
            leading: Icon(
              Icons.home,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Home",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          /* ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 0);
            },
            leading: Icon(
              Icons.notifications,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Notifications",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),*/
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Cart');
            },
            leading: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Cart",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 2);
            },
            leading: Icon(
              Icons.history,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Order History",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          /*ListTile(
            dense: true,
            title: Text(
              "Application Preferences",
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Help');
            },
            leading: Icon(
              Icons.help,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Help & Support",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Settings');
            },
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Settings",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Languages');
            },
            leading: Icon(
              Icons.translate,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Languages",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),*/
          ListTile(
            onTap: () {


            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Log out",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            dense: true,
            title: Text(
              "Version 0.0.1",
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

}
