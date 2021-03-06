import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DecoratedText extends StatelessWidget {
  final String displayText;
  final FontWeight fontWeight;
  final double fontSize;
  final Alignment alignment;
  final Color textColor;

  DecoratedText(this.displayText,
      {this.fontWeight = FontWeight.normal,
      this.fontSize = 12.0,
      this.alignment = Alignment.topLeft,
      this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: alignment,
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          displayText,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: fontWeight,
              fontSize: this.fontSize,
              color: textColor),
        ));
  }
}
