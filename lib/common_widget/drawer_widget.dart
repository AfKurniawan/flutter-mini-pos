
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String id;
  String email;
  String address;
  String phone = "";
  String name = "";
  String status;
  String baddress;
  String bphone;
  String usertype;
  String storeid;
  String photo;

  String userid;
  String _response = '';
  SharedPreferences prefs;

  @override
  void initState() {
    getPreferences();
    super.initState();
  }

  getPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userid = prefs.getString("userid");
      print("userid from preferences $userid");
    });
  }








  Future<Null> clearPreferences() async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();*/

    //Navigator.of(context).pushNamed('/Login');
    /*Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        LoginPage()), (Route<dynamic> route) => false);*/

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    //prefs.remove('login');
    setState(() {
      Navigator.pushReplacementNamed(context, '/');
    });


  }

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[

          GestureDetector(
            onTap: () {
              //Navigator.of(context).pushNamed('/Profile', arguments: 1);
            },


            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.1),
//              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
              ),


              accountName: Text(
                //"nama",
                name,
                style: Theme.of(context).textTheme.title,
              ),
              accountEmail: Text(
                phone,
                // "phoo",
                style: Theme.of(context).textTheme.caption,
              ),

              currentAccountPicture:
                  photo == null ?
                  Center(
                    child: new SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: const CircularProgressIndicator(
                          value: null,
                          strokeWidth: 1.0,
                        )),
                  )
                  :
              CircleAvatar(
                backgroundColor: Theme.of(context).accentColor,
                backgroundImage: AssetImage("assets/images/user"),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages');
            },
            leading: Icon(
              Icons.home,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Home",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          /* ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 0);
            },
            leading: Icon(
              Icons.notifications,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Notifications",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),*/
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Cart');
            },
            leading: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Cart",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Pages', arguments: 2);
            },
            leading: Icon(
              Icons.history,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Order History",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          /*ListTile(
            dense: true,
            title: Text(
              "Application Preferences",
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Help');
            },
            leading: Icon(
              Icons.help,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Help & Support",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Settings');
            },
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Settings",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushNamed('/Languages');
            },
            leading: Icon(
              Icons.translate,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Languages",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),*/
          ListTile(
            onTap: () {

              clearPreferences();

            },
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).focusColor.withOpacity(1),
            ),
            title: Text(
              "Log out",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          ListTile(
            dense: true,
            title: Text(
              "Version 0.0.1",
              style: Theme.of(context).textTheme.body1,
            ),
            trailing: Icon(
              Icons.remove,
              color: Theme.of(context).focusColor.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );

  }

}
