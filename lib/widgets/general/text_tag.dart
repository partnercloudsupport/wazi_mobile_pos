import 'package:flutter/material.dart';

class TextTag extends StatelessWidget {
  final String displayText;

  TextTag({@required this.displayText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(12.0)),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 12.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
