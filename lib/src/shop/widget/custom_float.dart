import 'package:flutter/material.dart';
import 'package:flutter_deltaprima_pos/style/theme.dart';

class CustomFloat extends StatelessWidget {
  final IconData icon;
  final Widget builder;
  final VoidCallback qrCallback;
  final isMini;

  CustomFloat({this.icon, this.builder, this.qrCallback, this.isMini = false});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      clipBehavior: Clip.antiAlias,
      elevation: 6,
      mini: isMini,
      onPressed: qrCallback,
      child: Ink(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(colors: AppTheme.kitGradients)),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            // builder
          ],
        ),
      ),
    );
  }
}
