import 'package:flutter/material.dart';
import 'package:flutter_mini_pos/custom_route.dart';
import 'package:flutter_mini_pos/main_page.dart';
import 'package:flutter_mini_pos/src/cart/pages/cart_list_page.dart';
import 'package:flutter_mini_pos/src/home/pages/home_page.dart';
import 'package:flutter_mini_pos/src/login/pages/login_page.dart';
import 'package:flutter_mini_pos/src/pos/pages/pos_scan_page.dart';
import 'package:flutter_mini_pos/src/products/pages/detail_product_page.dart';
import 'package:flutter_mini_pos/src/products/pages/scan_products_page.dart';
import 'package:flutter_mini_pos/src/shop/pages/shop_details.dart';
import 'package:flutter_mini_pos/src/shop/pages/shop_list.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      '/': (_) => LoginPage(),
      '/home': (_) => Homepage(),
      '/cart_page'  : (_) => CartListPage(),
     // '/main_page'  : (_) => MainPage(),
   //   '/login_page' : (_) => LoginPage(),
      '/shop_list_page' : (_) => ShopListPage()
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

      case "products":
        return CustomRoute<bool>(
          builder: (BuildContext context) => ScanProductPage(model: settings.arguments)
        );

      case "pos_scan_product":
        return CustomRoute<bool>(
          builder: (BuildContext context) => PosScanPage(model: settings.arguments)
        );

      case "detail_product":
        return CustomRoute<bool>(
          builder: (BuildContext context) => DetailProductPage(model: settings.arguments)
        );

      case 'main_page':
        return MaterialPageRoute(
            builder: (_) => MainPage(
              currentTab: settings.arguments,
            ));

    }
  }
}