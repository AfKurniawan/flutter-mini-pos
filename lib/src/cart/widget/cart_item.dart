import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_deltaprima_pos/constants/apis.dart';
import 'package:flutter_deltaprima_pos/src/cart/models/cart_list_model.dart';
import 'package:flutter_deltaprima_pos/src/cart/pages/cart_list_page.dart';
import 'package:flutter_deltaprima_pos/src/cart/services/delete_cart_service.dart';
import 'package:flutter_deltaprima_pos/style/light_color.dart';
import 'package:http/http.dart';

class CartItem extends StatefulWidget {

  CartListPage cartListPage;
  Cart cart;
  CartItem({Key key, this.cart, this.cartListPage}) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {

  CartListPage cartListPage;
  DeleteCartService deleteCartService;

  @override
  void initState() {

    super.initState();
    cartListPage = widget.cartListPage;
    deleteCartService = new DeleteCartService();
  }

  updateCartState(String id) {
    deleteCartService.delete(
        Api.DELETE_CART, {'cart_id': id, 'status': 'onDeleted'}).then((response){
      if(response.error == false){
        setState(() {
          print("DELETETETETETETETETETET");
          Navigator.pushReplacementNamed(context, '/cart_page');
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          widget.cart.image == "" ? noImage() :
          imageWidget(),
          SizedBox(width: 15),
          newTextWidget(),

        ],
      ),
    );
  }

  Widget noImage(){
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(13)),
      child: Container(
        height: 55,
        width: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: randomColor(),
        ),
      ),
    );
  }

  Widget imageWidget(){
    return Container(
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(5)),
          image: DecorationImage(
              image: NetworkImage(
                  Api.PRODUCTS_IMAGES_URL + widget.cart.image),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget newTextWidget(){
    return Flexible(
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(),
                    Text(
                      widget.cart.name,
                      overflow:
                      TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueGrey)),

                    SizedBox(height: 3.0),
                    Text(
                      "Rp. ${widget.cart.sellingPrice}",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w900,
                        color: LightColor.skyBlue,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Qty: ${widget.cart.quantity}",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: LightColor.purpleLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 3),
                    Row(
                      children: <Widget>[
                        Text(
                          "SubTotal",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: LightColor.lightOrange,
                          ),
                        ),
                        SizedBox(width: 3),
                        Text(
                          "Rp. ${widget.cart.total}",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),

                    Divider(),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      setState(() {
                        updateCartState(widget.cart.cartId);
                      });
                    },
                    iconSize: 30,
                    padding: EdgeInsets.symmetric(
                        horizontal: 5),
                    icon:
                    Icon(Icons.delete_outline),
                    color:
                    Theme.of(context).hintColor,
                  ),
                ],
              ),
            ],
          ),
        );

  }

  Color randomColor() {
    var random = Random();
    final colorList = [
      Theme.of(context).primaryColor,
      LightColor.orange,
      LightColor.green,
      LightColor.grey,
      LightColor.lightOrange,
      LightColor.skyBlue,
      LightColor.titleTextColor,
      Colors.red,
      Colors.brown,
      LightColor.purpleExtraLight,
      LightColor.skyBlue,
    ];
    var color = colorList[random.nextInt(colorList.length)];
    return color;
  }
}
