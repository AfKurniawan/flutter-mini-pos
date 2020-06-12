

import 'package:flutter/material.dart';
import 'package:flutter_mini_pos/configs/app_config.dart';

class CustomDialogSuccess extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;


  CustomDialogSuccess({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Color.fromRGBO(143, 144, 251, 3),
      child: dialogContent(context),

    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
               // color: Theme.of(context).primaryColorDark,
                color: Colors.black12,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[

              SizedBox(height: 30),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 24.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, '/create_shop');// To close the dialog
                  },
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),

        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          top: Consts.padding,

          child: CircleAvatar(
            child: Image.asset(
              'assets/images/icon_success.png',
              width: 90,
              color: Colors.white
            ),

            backgroundColor: Color.fromRGBO(143, 148, 251, 1),
            radius: Consts.avatarRadius,
          ),
        ),
      ],
    );
  }
}