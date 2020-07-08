import 'package:flutter/material.dart';
import 'package:flutter_mini_pos/animation/FadeAnimation.dart';
import 'package:flutter_mini_pos/common_widget/form_field_widget.dart';
import 'package:flutter_mini_pos/common_widget/icon_badge.dart';
import 'package:flutter_mini_pos/common_widget/inkwell_button_widget.dart';
import 'package:flutter_mini_pos/constants/apis.dart';
import 'package:flutter_mini_pos/localization/localization.dart';
import 'package:flutter_mini_pos/src/pos/services/get_label_count_service.dart';
import 'package:flutter_mini_pos/src/products/models/products_model.dart';
import 'package:flutter_mini_pos/style/light_color.dart';
import 'package:fluttericon/linearicons_free_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailProductPageNew extends StatefulWidget {
  DetailProductPageNew({Key key, this.item}) : super(key: key);
  final Item item;
  @override
  _DetailProductPageNewState createState() => _DetailProductPageNewState();
}

class _DetailProductPageNewState extends State<DetailProductPageNew> {
  Item item;
  TextEditingController quantityController = new TextEditingController();
  LabelCountService labelCountService;
  SharedPreferences prefs;
  String labelcartcount;
  String userid;
  String shopid;
  var mediaQuery;

  @override
  void initState() {
    labelCountService = new LabelCountService();
    item = widget.item;
    //mediaQuery = MediaQuery.of(context);
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      print("Nama Substring, $userid");
      userid = prefs.getString('userid');
      shopid = prefs.getString('shopid');
      getLabelCartCount();
    });
  }

  void getLabelCartCount() async {
    labelCountService.getLabelCount(Api.GET_LABEL_COUNT,
        {'user_id': userid, 'shop_id': shopid}).then((response) {
      if (response.error == false) {
        setState(() {
          labelcartcount = response.count.count;
          print("Total Cart $labelcartcount");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).orientation == Orientation.portrait){
      return Scaffold(
        body: verticalLayout(),
      );
    } else {
      return Scaffold(
        body: horizontalLayout(),
      );
    }

  }

  Widget verticalLayout(){
    var mediaQuery = MediaQuery.of(context);
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: mediaQuery.size.height / 1.7,
          child: FadeAnimation(
              1.3,
              Image.network(
                Api.PRODUCTS_IMAGES_URL + item.image,
                fit: BoxFit.cover,
              )),
        ),
        Positioned(
          top: 20,
          width: mediaQuery.size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: IconButton(
                      icon: IconBadge(
                        icon: LineariconsFree.cart,
                        size: 24.0,
                        count: labelcartcount,
                      ),
                      color: LightColor.grey,
                      onPressed: () {
                        Navigator.pushNamed(context, "/cart_page");
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height / 2.1,
            child: FadeAnimation(
                1.2,
                Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FadeAnimation(
                                1.3,
                                Text(
                                  item.variant,
                                  style: TextStyle(
                                      color: Color.fromRGBO(97, 90, 90, .54),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                              FadeAnimation(
                                1.3,
                                Text(
                                  item.name,
                                  style: TextStyle(
                                      color: Color.fromRGBO(97, 90, 90, 1),
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              Divider(),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  FadeAnimation(
                                    1.4,
                                    Container(
                                      child: Text(
                                        "Rp. ${item.purchasePrice}",
                                        style: TextStyle(
                                            color: LightColor.purple,
                                            height: 1.4,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                  FadeAnimation(
                                    1.3,
                                    Text(
                                      "Barcode: ${item.barcode}",
                                      style: TextStyle(
                                          color: Color.fromRGBO(97, 90, 90, .54),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),


                              SizedBox(
                                height: mediaQuery.size.height / 7,
                              ),
                              FadeAnimation(
                                  1.3,
                                  FormFieldWidget(
                                    hint: "Quantity",
                                  )),

                              SizedBox(
                                height: 10,
                              ),
                          FadeAnimation(
                          1.4,
                          InkWellButtonWidget(
                            btnText: "Add to Cart",
                            myIcon: null,
                          ),
                          ),

                            ],
                          ),
                        ))))),
      ],
    );
  }

  Widget horizontalLayout(){
    var mediaQuery = MediaQuery.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: mediaQuery.size.width,
          child: Stack(
            children: <Widget>[
              Container(
                child: Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: mediaQuery.size.height / 1.5,
                  child: FadeAnimation(
                      1.3,
                      Image.network(
                        Api.PRODUCTS_IMAGES_URL + item.image,
                        fit: BoxFit.cover,
                      )),
                ),
              ),
              myHorizontalAppbar(),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: FadeAnimation(
                      1.2,
                      Container(
                          padding: const EdgeInsets.only(left:20.0, right: 20, top: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Container(
                            child: SingleChildScrollView(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          FadeAnimation(
                                            1.3,
                                            Text(
                                              item.variant,
                                              style: TextStyle(
                                                color: Color.fromRGBO(97, 90, 90, .54),
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                          FadeAnimation(
                                            1.3,
                                            Text(
                                              "Barcode: ${item.barcode}",
                                              style: TextStyle(
                                                color: Color.fromRGBO(97, 90, 90, .54),
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child: FadeAnimation(
                                              1.3,
                                              Text(
                                                item.name,
                                                style: TextStyle(
                                                    color: Color.fromRGBO(97, 90, 90, 1),
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          FadeAnimation(
                                            1.4,
                                            Padding(
                                              padding: const EdgeInsets.only(top:10.0),
                                              child: Container(
                                                child: Text(
                                                  "Rp. ${item.purchasePrice}",
                                                  style: TextStyle(
                                                    color: LightColor.purple,
                                                    height: 1.4,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),

                                      SizedBox(
                                        height: 20,
                                      ),
                                      FadeAnimation(
                                          1.3,
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                width: mediaQuery.size.width /1.5,
                                                child: FormFieldWidget(
                                                  hint: "Quantity",
                                                ),
                                              ),
                                              Container(
                                                width: mediaQuery.size.width /4,
                                                child: FadeAnimation(
                                                  1.4,
                                                  InkWellButtonWidget(
                                                    btnText: "Add to Cart",
                                                    myIcon: (Icon(LineariconsFree.cart,
                                                      color: Colors.white,
                                                    )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),

                                      SizedBox(
                                        height: 5,
                                      ),

                                    ],
                                  ),
                                )
                            ),
                          )
                      )
                  )
              ),
            ],
          ),
        ),

      ],
    );

  }

  Widget myHorizontalAppbar(){
    return Positioned(
      top: 20,
      width: MediaQuery.of(context).size.width / 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  icon: IconBadge(
                    icon: LineariconsFree.cart,
                    size: 24.0,
                    count: labelcartcount,
                  ),
                  color: LightColor.grey,
                  onPressed: () {
                    Navigator.pushNamed(context, "/cart_page");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
