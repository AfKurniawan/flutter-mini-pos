import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_deltaprima_pos/common_widget/icon_badge.dart';
import 'package:flutter_deltaprima_pos/src/cart/pages/cart_page.dart';
import 'package:flutter_deltaprima_pos/src/pos/services/get_label_count_service.dart';
import 'package:flutter_deltaprima_pos/src/register/pages/register.dart';
import 'package:flutter_deltaprima_pos/src/shop/pages/create_shop.dart';
import 'package:flutter_deltaprima_pos/src/shop/pages/shop_home.dart';
import 'package:flutter_deltaprima_pos/src/shop/pages/shop_list.dart';
import 'package:flutter_deltaprima_pos/src/shop/widget/custom_float.dart';
import 'package:flutter_deltaprima_pos/style/light_color.dart';
import 'package:flutter_deltaprima_pos/style/extention.dart';
import 'package:flutter_deltaprima_pos/style/theme.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  PageController _pageController;
  int _page = 0;
  String title;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  LabelCountService labelCountService;


  @override
  void initState() {
    super.initState();
    labelCountService = new LabelCountService();
    _pageController = PageController();
    title = "List Toko";
  }





  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()=>Future.value(false),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: myAppBar(),
        body: bodyPageView(),
        bottomNavigationBar: myBottomAppbar(),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: CustomFloat(
          icon: Icons.add,
          qrCallback: (){
            print("Button Clicked Cuk");
          },
        ),

      ),
    );
  }

  Widget bodyPageView(){
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: _pageController,
      onPageChanged: onPageChanged,
      children: <Widget>[
        ShopListPage(),
        CartPage()
      ],
    );
  }



  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
      switch (page){
        case 0: { title = 'List Toko'; }
        break;
        case 1: { title = 'Timer'; }
        break;
      }
    });
  }



  Widget myAppBar(){
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: AppBar(
        centerTitle: true,
        title: Text(title,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 1,
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
        ],
      ),
    );
  }

  Widget myBottomAppbar(){
    return BottomAppBar(
      elevation: 5,
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(width:7),
          IconButton(
            icon: Icon(
              Icons.store,
              size: 24.0,
            ),
            color: _page == 0
                ? Color.fromRGBO(143, 148, 251, .5)
                : Color.fromRGBO(143, 148, 251, 1),
            onPressed: ()=>_pageController.jumpToPage(0),
          ),
          SizedBox(width: 80),
          IconButton(
            icon: Icon(Icons.shopping_cart,
              size: 24.0,
            ),
            color: _page == 1
                ?  Color.fromRGBO(143, 148, 251, .5)
                :  Color.fromRGBO(143, 148, 251, 1),
            onPressed: ()=>_pageController.jumpToPage(2),
          ),
          SizedBox(width:7),
        ],
      ),
      color: Theme.of(context).backgroundColor,
      shape: CircularNotchedRectangle(),
    );
  }
}
