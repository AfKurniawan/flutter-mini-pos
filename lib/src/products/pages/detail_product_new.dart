import 'package:flutter/material.dart';
import 'package:flutter_mini_pos/common_widget/form_field_widget.dart';
import 'package:flutter_mini_pos/common_widget/inkwell_button_widget.dart';
import 'package:flutter_mini_pos/constants/apis.dart';
import 'package:flutter_mini_pos/src/products/models/products_model.dart';
import 'package:flutter_mini_pos/style/light_color.dart';

class DetailProductPageNew extends StatefulWidget {

  DetailProductPageNew({Key key, this.item}) : super(key: key);
  final Item item;
  @override
  _DetailProductPageNewState createState() => _DetailProductPageNewState();
}

class _DetailProductPageNewState extends State<DetailProductPageNew> {

  Item item;
  @override
  void initState() {
    // TODO: implement initState
    item = widget.item;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Hero(
                    tag: item.id,
                    child: Container(
                      width: double.infinity,
                      height: 300.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFE5F2FF),
                        image: DecorationImage(
                          image: NetworkImage(Api.PRODUCTS_IMAGES_URL+item.image),
                          fit: BoxFit.cover
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 30.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back_ios),
                          color: Colors.black,
                        ),
                        IconButton(
                          onPressed: () => print('Menu'),
                          icon: Icon(Icons.menu),
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 290.0,
                width: MediaQuery.of(context).size.width /1.04,
                transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 0.5,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 28.0, top:30, right:28, bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${item.name}'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      Text(
                        '${item.variant}',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Rp. ${item.sellingPrice}',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Divider(),

                      SizedBox(height: 40),
                      FormFieldWidget(
                        hint: "Quantity",
                      ),

                    ],
                  ),
                ),
              ),



            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(left:10.0, right: 10.0, bottom: 20),
        child: InkWellButtonWidget(
          btnAction: (){

          },
          btnText: "Add to Cart",
        )
      ),
    );
  }
}
