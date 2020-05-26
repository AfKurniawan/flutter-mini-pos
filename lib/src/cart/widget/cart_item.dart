import 'package:flutter/material.dart';
import 'package:flutter_deltaprima_pos/constants/apis.dart';
import 'package:flutter_deltaprima_pos/src/cart/models/cart.dart';
import 'package:flutter_deltaprima_pos/style/light_color.dart';


class CartItem extends StatefulWidget {

  Cart cart;

  CartItem({
    Key key, this.cart})
      :super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: InkWell(
        onTap: (){
        },
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 0.0, right: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.width/3.5,
                width: MediaQuery.of(context).size.width/3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    Api.PRODUCTS_IMAGES_URL + widget.cart.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.cart.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.blueGrey
                  ),
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
                    Text(
                      "Rp. ${widget.cart.total}",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: LightColor.lightOrange,
                      ),
                    ),


                  ],
                ),



              ],

            ),
          ],
        ),
      ),
    );
  }
}
