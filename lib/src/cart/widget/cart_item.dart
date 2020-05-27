import 'package:flutter/material.dart';
import 'package:flutter_deltaprima_pos/constants/apis.dart';
import 'package:flutter_deltaprima_pos/src/cart/models/cart_list_model.dart';
import 'package:flutter_deltaprima_pos/style/light_color.dart';

class CartItem extends StatefulWidget {

  Cart cart;
  CartItem({Key key, this.cart}) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          imageWidget(),
          SizedBox(width: 15),
          newTextWidget(),

        ],
      ),
    );
  }

  Widget imageWidget(){
    return Container(
      child: Container(
        height: 90,
        width: 90,
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
                    Text(
                      widget.cart.name,
                      overflow:
                      TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.blueGrey)),
                    SizedBox(height: 10.0),
                    Text(
                      "Rp. ${widget.cart.sellingPrice}",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w900,
                        color: LightColor.skyBlue,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Qty: ${widget.cart.quantity}",
                      style: TextStyle(
                        fontSize: 13.0,
                        color: LightColor.purpleLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
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

  Widget textWidgetRakanggo(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width / 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.cart.name,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.blueGrey),
              ),
              SizedBox(height: 10.0),
              Text(
                "Rp. ${widget.cart.sellingPrice}",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w900,
                  color: LightColor.skyBlue,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "Qty: ${widget.cart.quantity}",
                style: TextStyle(
                  fontSize: 13.0,
                  color: LightColor.purpleLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "SubTotal",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: LightColor.lightOrange,
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ],
          ),
        ),
        Container(
          color: Colors.blueGrey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              IconButton(
                iconSize: 30,
                padding: EdgeInsets.symmetric(horizontal: 9),
                icon: Icon(Icons.delete_outline),
                color: Theme.of(context).hintColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
