import 'package:flutter/material.dart';
import 'package:wazi_mobile_pos/widgets/general/rectangle_avatar.dart';

class RectangleLogo extends StatelessWidget {
  final String image;
  final double size;
  final bool outline;
  final Color outlineColor;
  final bool isTransparent;

  RectangleLogo(
      {@required this.image,
      this.outline = false,
      this.outlineColor = Colors.orange,
      this.size = 36,
      this.isTransparent = false});

  @override
  Widget build(BuildContext context) {
    double max = size;
    double min = 32;
    if (MediaQuery.of(context).size.width > 500) {
      double maxfactor = MediaQuery.of(context).size.width / 500;

      max = max * maxfactor;
      print(maxfactor);
    }

    print(max);

    if (max < min) max = min;

    Widget avatar = Container(
      padding: EdgeInsets.all(2),
      child: RectangleAvatar(
          maxRadius: max,
          backgroundColor: isTransparent ? Colors.transparent : Colors.white,
          foregroundColor: isTransparent ? Colors.transparent : Colors.white,
          backgroundImage: AssetImage(this.image)),
    );

    return avatar;
  }
}
