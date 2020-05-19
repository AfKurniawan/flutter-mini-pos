import 'package:flutter/material.dart';
import 'package:flutter_deltaprima_pos/localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<DetailPage> {
  SharedPreferences prefs;
  bool isLogin;

  @override
  void initState() {
    super.initState();
  }

  Future<Null> clearPrefs() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    setState(() {
      print("login state in Home Page is ${prefs.getBool("isLogin")}");
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: Container(
                height: 600,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://image.freepik.com/free-vector/abstract-galaxy-background_1199-247.jpg"),
                      fit: BoxFit.cover),
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(143, 148, 251, 1),
                    Color.fromRGBO(143, 148, 251, .6),
                  ]),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  "Rubber Tree",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                child: Text(
                                  "Robust and dramatic, with glossy leaves",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),


                              priceSection(),


                              SizedBox(
                                height: 20,
                              ),

                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          margin: EdgeInsets.all(20),
                          child: Image.network(
                              "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fthumbs.dreamstime.com%2Fb%2Fyucca-palm-tree-pot-young-plant-many-green-leaves-black-background-56128357.jpg&f=1&nofb=1"),
                          height: 200,
                          width: 160,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    formQuantity(),

                    SizedBox(
                      height: 20,
                    ),

                    Row(
                      children: <Widget>[
                        totalSection(),

                      ],
                    )
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                height: 100,
              ),
            ),
            _buildBottomButton(),
          ],
        ),
      ),
    ));
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Color(0xff0A2149)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Add to Cart - ",
              style: TextStyle(
                //color: Color(0xff0A1149),
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "\$55",
              style: TextStyle(
                //color: Color(0xff799271),
                color: Colors.white70,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget formQuantity() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate("quantity"),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Color(0xff11323B),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Container(
                width: 130,
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[300], width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red[300], width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.red[300], width: 1.5),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      fillColor: Colors.white),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Color(0xff11323B),
                ),
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: 30,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget priceSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(143, 148, 251, .6),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        //border: Border.all(width: 1.0, color: Colors.white)
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.attach_money, color: Colors.white),
                SizedBox(width: 2),
                Text("6000",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget totalSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(143, 148, 251, .6),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        //border: Border.all(width: 1.0, color: Colors.white)
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.attach_money, color: Colors.white),
                SizedBox(width: 2),
                Text("6000",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
