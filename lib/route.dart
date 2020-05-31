import 'package:flutter/material.dart';
import 'package:flutter_deltaprima_pos/configs/route_arguments.dart';
import 'package:flutter_deltaprima_pos/custom_route.dart';
import 'package:flutter_deltaprima_pos/src/home/pages/home.dart';
import 'package:flutter_deltaprima_pos/src/login/pages/login_page.dart';
import 'package:flutter_deltaprima_pos/src/register/pages/register_page.dart';
import 'package:flutter_deltaprima_pos/src/shop/pages/create_shop.dart';
import 'package:flutter_deltaprima_pos/src/shop/pages/shop_details.dart';
import 'package:flutter_deltaprima_pos/src/shop/pages/shop_home.dart';
import 'package:flutter_deltaprima_pos/src/shop/pages/shop_list.dart';

class MyRoute{
  static Route<dynamic> generateRoute(RouteSettings settings) {

      final RouteArguments args = settings.arguments;

      switch (settings.name){
        case '/':
          return MaterialPageRoute(builder: (_) => ShopListPage());
        case '/login':
          return MaterialPageRoute(builder: (_) => LoginPage());
        case '/register':
          return MaterialPageRoute(builder: (_) => RegisterPage());
        case '/home':
          return MaterialPageRoute(builder: (_) => Homepage());
        case '/create_shop':
          return MaterialPageRoute(builder: (_) => CreateShopPage());

        case "shop_home":
          return CustomRoute<bool>(
              builder: (BuildContext context) => ShopDetailPage(model: settings.arguments,));

//        case '/shop_home' :
//          return MaterialPageRoute(builder: (context) => ShopHomePage(argumen: settings.arguments));
        case '/shop_list' :
          return MaterialPageRoute(builder: (_) => ShopListPage());
      }
  }
}
