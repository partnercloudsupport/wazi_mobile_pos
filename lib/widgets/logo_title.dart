import 'package:flutter/material.dart';
import 'package:wazi_mobile_pos/widgets/circle_logo.dart';
import 'package:wazi_mobile_pos/widgets/title_text.dart';

class LogoTitle extends StatelessWidget {
  final String image;
  final String title;

  LogoTitle({@required this.image, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleLogo(
          image: this.image,
          outline: true,
          outlineColor: Theme.of(context).accentColor,
        ),
        TitleDefault(
          title: this.title,
          size: 18.0,
        )
      ],
    );
  }
}
