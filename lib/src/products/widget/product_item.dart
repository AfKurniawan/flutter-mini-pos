import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mini_pos/src/products/models/products_model.dart';
import 'package:flutter_mini_pos/constants/apis.dart';
import 'package:flutter_mini_pos/src/cart/models/cart_list_model.dart';
import 'package:flutter_mini_pos/src/cart/pages/cart_list_page.dart';
import 'package:flutter_mini_pos/src/cart/services/delete_cart_service.dart';
import 'package:flutter_mini_pos/src/products/pages/product_list_page.dart';
import 'package:flutter_mini_pos/style/light_color.dart';
import 'package:http/http.dart';

class ProductItem extends StatefulWidget {

  ProductListPage listPage;
  Item product;
  ProductItem({Key key, this.product, this.listPage}) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {

  ProductListPage listPage;

  @override
  void initState() {

    super.initState();
    listPage = widget.listPage;
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 4, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          widget.product.image == "" ? noImage() :
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
                  Api.PRODUCTS_IMAGES_URL + widget.product.image),
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
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, "/product_detail", arguments: widget.product);
                  },
                  child: Container(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: <Widget>[
                        Divider(),
                        Text(
                          widget.product.name,
                          overflow:
                          TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Colors.blueGrey)),

                        SizedBox(height: 3.0),

                        Text(
                          "Barcode: ${widget.product.barcode}",
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
                              "Price",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                color: LightColor.lightOrange,
                              ),
                            ),
                            SizedBox(width: 3),
                            Text(
                              "Rp. ${widget.product.sellingPrice}",
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
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.arrow_forward_ios,
                  size: 20,
                  ),
//                  IconButton(
//                    onPressed: () {
//
//                    },
//                    iconSize: 20,
//                    padding: EdgeInsets.symmetric(
//                        horizontal: 5),
//                    icon:
//                    Icon(Icons.arrow_forward_ios),
//                    color:
//                    Theme.of(context).hintColor,
//                  ),
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
