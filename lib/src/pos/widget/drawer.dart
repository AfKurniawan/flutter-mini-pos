import 'package:flutter/material.dart';
import 'package:flutter_mini_pos/style/extention.dart';

class DrawerMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.1),
//              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
              ),


              accountName: Text(
                "Fajar",
                style: Theme.of(context).textTheme.title,
              ),
              accountEmail: Text(
                "1234567880",
                style: Theme.of(context).textTheme.caption,
              ),

              currentAccountPicture:  ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(13)
                ),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                  ),
                  child: Image.asset("assets/images/user.png", fit: BoxFit.fill),
                ),
              ).p(8),
            ),
          ),

          ListTile(
            onTap: () {
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
