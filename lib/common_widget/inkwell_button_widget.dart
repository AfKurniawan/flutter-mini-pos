import 'package:flutter/material.dart';

class InkWellButtonWidget extends StatelessWidget {

  final VoidCallback btnAction;
  final String btnText;
  InkWellButtonWidget({
    @required this.btnAction,
    @required this.btnText
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: btnAction,
      splashColor: Color.fromRGBO(143, 148, 251, 1),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(143, 148, 251, 1),
              Color.fromRGBO(143, 148, 251, .6),
            ])),
        child: Center(
          child: Text(
            btnText,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
