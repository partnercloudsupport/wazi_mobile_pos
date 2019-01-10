import 'package:flutter/material.dart';

class LoadingCircle extends StatelessWidget {
  final String displayText;

  LoadingCircle({this.displayText});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      child: CircularProgressIndicator(
        semanticsLabel: displayText,
      ),
    ));
  }
}
