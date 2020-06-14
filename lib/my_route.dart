import 'package:flutter/material.dart';
import 'package:flutter_mini_pos/custom_route.dart';
import 'package:flutter_mini_pos/splash_page.dart';
import 'package:flutter_mini_pos/src/products/pages/detail_product_new.dart';
import 'package:flutter_mini_pos/src/products/pages/detail_product_page.dart';
import 'package:flutter_mini_pos/custom_route.dart';
import 'package:flutter_mini_pos/main_page.dart';
import 'package:flutter_mini_pos/src/cart/pages/cart_list_page.dart';
import 'package:flutter_mini_pos/src/home/pages/home_page.dart';
import 'package:flutter_mini_pos/src/login/pages/login_page.dart';
import 'package:flutter_mini_pos/src/pos/pages/scan_product_page.dart';
import 'package:flutter_mini_pos/src/products/pages/product_list_page.dart';
import 'package:flutter_mini_pos/src/shop/pages/shop_details.dart';
import 'package:flutter_mini_pos/src/shop/pages/shop_list.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      '/' : (_) => SplashPage(),
     '/login_page' : (_) => LoginPage(),
      '/home': (_) => Homepage(),
      '/cart_page'  : (_) => CartListPage(),
      '/shop_list_page' : (_) => ShopListPage(),
      '/scan_product' : (_) => ScanProductPage()
    };
  }

  static Route onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    switch (pathElements[1]) {
      case "shop_detail":
        return CustomRoute<bool>(
            builder: (BuildContext context) => ShopDetailPage(model: settings.arguments)
        );


      case "product_list":
        return CustomRoute<bool>(
          builder: (BuildContext context) => ProductListPage(model: settings.arguments)
        );

      case "product_detail":
        return CustomRoute<bool>(
          builder: (BuildContext context) => DetailProductPage(item: settings.arguments)
        );

      case "product_detail_new":
        return CustomRoute<bool>(
            builder: (BuildContext context) => DetailProductPageNew(item: settings.arguments)
        );


      case 'main_page':
        return MaterialPageRoute(
            builder: (_) => MainPage(
              currentTab: settings.arguments,
            ));

    }
  }
}