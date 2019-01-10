import 'package:flutter/material.dart';

class LongText extends StatelessWidget {
  final String displayText;
  final FontWeight fontWeight;
  final double fontSize;
  final Alignment alignment;

  LongText(this.displayText,
      {this.fontWeight = FontWeight.normal,
      this.fontSize = 10.0,
      this.alignment = Alignment.topLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: DefaultTextStyle(
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        textAlign: TextAlign.start,
        child: Text(
          displayText,
        ),
        style: TextStyle(
            color: Colors.black,
            fontStyle: FontStyle.normal,
            fontWeight: fontWeight,
            fontSize: this.fontSize),
      ),
    );
  }
}
