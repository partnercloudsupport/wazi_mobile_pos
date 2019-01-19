import 'package:flutter/material.dart';

class LoadingCircle extends StatelessWidget {
  final String displayText;

  LoadingCircle({this.displayText});

  @override
  Widget build(BuildContext context) {
    var targetHeight = MediaQuery.of(context).size.height / 3;
    var targetWidth = MediaQuery.of(context).size.height * 0.6;

    return Center(
        child: SizedBox(
      height: targetHeight,
      width: targetWidth,
      child: CircularProgressIndicator(
        semanticsLabel: displayText,
      ),
    ));
  }
}
