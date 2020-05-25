import 'package:flutter/material.dart';
import 'package:flutter_deltaprima_pos/custom_route.dart';
import 'package:flutter_deltaprima_pos/main_screen.dart';
import 'package:flutter_deltaprima_pos/src/home/pages/home.dart';
import 'package:flutter_deltaprima_pos/src/products/pages/scan_products.dart';
import 'package:flutter_deltaprima_pos/src/shop/pages/shop_details.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      '/': (_) => MainScreen(),
      '/home': (_) => Homepage(),
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
          builder: (BuildContext context) => ProductDetails(model: settings.arguments)
        );

    }
  }
}