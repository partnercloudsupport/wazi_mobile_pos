import 'package:flutter/material.dart';

class CircleLogo extends StatelessWidget {
  final String image;
  final double size;
  final bool outline;
  final Color outlineColor;
  final bool isTransparent;

  CircleLogo(
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
      max = 28 * maxfactor;
    }

    if (max < min) max = min;

    Widget logo = Container(
      padding: EdgeInsets.all(2),
      child: CircleAvatar(
        backgroundColor: isTransparent ? Colors.transparent : Colors.white,
        foregroundColor: isTransparent ? Colors.transparent : Colors.white,
        child: Image.asset(
          this.image,
          fit: BoxFit.cover,
        ),
        maxRadius: max,
        minRadius: 32.0,
      ),
    );

    if (this.outline) {
      return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: outlineColor),
        child: logo,
      );
    } else {
      return logo;
    }
  }
}
