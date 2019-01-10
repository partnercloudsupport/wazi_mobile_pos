import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget {
  final String title;
  final double size;

  TitleDefault({@required this.title, this.size = 12.0});

  @override
  Widget build(BuildContext context) {
    return Text(
      this.title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: size),
    );
  }
}
