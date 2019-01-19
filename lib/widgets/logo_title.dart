import 'package:flutter/material.dart';

import 'package:wazi_mobile_pos/widgets/circle_logo.dart';
import 'package:wazi_mobile_pos/widgets/title_text.dart';

class LogoTitle extends StatelessWidget {
  final String image;
  final String title;

  LogoTitle({@required this.image, this.title});

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    children.add(CircleLogo(
      image: this.image,
      outline: true,
      outlineColor: Theme.of(context).accentColor,
    ));

    if (this.title != null && title.isNotEmpty)
      children.add(TitleDefault(
        title: this.title,
        size: 18.0,
      ));
    else
      children.add(SizedBox(
        height: 8.0,
      ));

    return Column(
      children: children,
    );
  }
}
