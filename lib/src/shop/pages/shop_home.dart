import 'package:flutter/material.dart';
import 'package:flutter_deltaprima_pos/route.dart';
import 'package:flutter_deltaprima_pos/src/shop/models/shop_model.dart';
import 'package:flutter_deltaprima_pos/src/shop/pages/create_shop.dart';

class ShopHomePage extends StatefulWidget {

   final String name;


  ShopHomePage({
    Key key,
    @required this.name
  }) : super(key: key);

  @override
  _ShopHomePageState createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name)
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(widget.name)
            ],
          ),
        ),
      ),
    );
  }
}
