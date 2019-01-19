import 'package:flutter/material.dart';
import 'package:wazi_mobile_pos/widgets/general/generic_form.dart';
import 'package:wazi_mobile_pos/widgets/general/loading_circle.dart';

class ProgressButton extends StatefulWidget {
  final FormButton formButton;
  final String text;

  ProgressButton(this.formButton, this.text);

  @override
  ProgressButtonState createState() {
    return new ProgressButtonState();
  }
}

class ProgressButtonState extends State<ProgressButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 5.0,
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
      child: _buildButtonChild(context),
      onPressed: () {
        setState(() {
          print("set busy state to true...");
          widget.formButton.isBusy = true;
        });

        widget.formButton.onPressed();

        setState(() {
          print("set busy state to false...");
          widget.formButton.isBusy = false;
        });
      },
      color: widget.formButton.color,
      textColor: widget.formButton.textColor,
    );
  }

  Widget _buildButtonChild(BuildContext context) {
    if (widget.formButton.isBusy) {
      return Text("Busy...");
    } else {
      return Text(widget.text);
    }
  }
}
