import 'package:flutter/material.dart';
import 'package:flutter_mini_pos/src/shop/models/shop_list_model.dart';
import 'package:flutter_mini_pos/src/shop/widget/custom_float.dart';
import 'package:flutter_mini_pos/style/theme.dart';

class ShopHomePage extends StatefulWidget {

   final Shops model;


  ShopHomePage({
    Key key,
    @required this.model
  }) : super(key: key);

  @override
  _ShopHomePageState createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage> {

  Shops shopmodel;

  @override
  void initState() {
    shopmodel = widget.model;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(shopmodel.id),
              Text(shopmodel.name),
              Text(shopmodel.phone),
              Text(shopmodel.address),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFloat(
        icon: Icons.add,
        qrCallback: (){
          print("Button Clicked Cuk");
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: myBottomBar(),
    );
  }

  Widget appBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40)
              ),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(143, 148, 251, 1),
                Color.fromRGBO(143, 148, 251, .6),
              ])
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white)),
        backgroundColor: Colors.blue[400],
        elevation: 3,
        title: Text(shopmodel.name, style: TextStyle(
            fontWeight: FontWeight.w300, color: Colors.white, fontSize: 24
        )),
        centerTitle: true,
      ),
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
