import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/widgets/general/decorated_text.dart';
import 'package:wazi_mobile_pos/widgets/general/loading_circle.dart';
import 'package:wazi_mobile_pos/widgets/general/progress_button.dart';

import 'package:wazi_mobile_pos/widgets/general/value_item.dart';
import 'package:wazi_mobile_pos/widgets/logo_title.dart';

class GenericForm extends StatefulWidget {
  final FormModel model;
  final String headerImage;
  final bool addHeader;
  final String headerTitle;
  final bool autoSize;
  final String formTitle;
  final String subTitle;
  final bool blur;

  GenericForm(
      {@required this.model,
      this.headerImage,
      this.addHeader,
      this.headerTitle,
      this.subTitle,
      this.formTitle,
      this.autoSize = false,
      this.blur = false});

  void addButton(
      {@required String text,
      @required Function onPressed,
      Color color,
      Color textColor,
      Stream<bool> loadingStream = null,
      FormButtonType type = FormButtonType.raisedButton}) {
    model.addButton(
        text: text,
        type: type,
        textColor: textColor,
        color: color,
        onPressed: onPressed,
        loadingStream: loadingStream);
  }

  void addRowButton(
      {@required String text,
      @required Function onPressed,
      Color color,
      Color textColor,
      FormButtonType type = FormButtonType.raisedButton}) {
    model.addButton(
        text: text,
        type: type,
        textColor: textColor,
        color: color,
        onPressed: onPressed);
  }

  void addField(
      {@required String fieldKey,
      @required String name,
      String initialValue,
      @required Function(String) validator,
      @required Function(String) onSave,
      bool obscureText = false,
      IconData icon,
      TextInputType inputType = TextInputType.text,
      TextAlign textAlign = TextAlign.left,
      TextInputAction inputAction = TextInputAction.next,
      TextCapitalization textCapitalization = TextCapitalization.none,
      TextStyle textStyle,
      bool autoCorrect = false,
      bool required = false,
      String regexPattern,
      String exampleValue}) {
    model.addField(
        fieldKey: fieldKey,
        name: name,
        onSave: onSave,
        validator: validator,
        exampleValue: exampleValue,
        obscureText: obscureText,
        autoCorrect: autoCorrect,
        icon: icon,
        initialValue: initialValue,
        inputAction: inputAction,
        inputType: inputType,
        regexPattern: regexPattern,
        required: required,
        textAlign: textAlign,
        textCapitalization: textCapitalization,
        textStyle: textStyle);
  }

  @override
  GenericFormState createState() {
    return GenericFormState();
  }
}

class FocusField {
  GlobalKey<State> fieldkey;
  FocusNode focusNode;
  TextFormField formField;

  FocusField(
      {@required this.formField,
      @required this.focusNode,
      @required this.fieldkey});
}

class FormModel extends Model {
  String key;
  List<FocusField> _fields = [];
  List<FormButton> _buttons = [];
  List<ValueItem> _valueItems = [];
  GlobalKey<FormState> _formKey = GlobalKey();

  List<FocusField> get fields {
    return List.from(_fields);
  }

  List<FormButton> get buttons {
    return _buttons;
  }

  List<ValueItem> get valueItems {
    return _valueItems;
  }

  GlobalKey<FormState> get formKey {
    return _formKey;
  }

  GlobalKey<FormState> setFormKey() {
    _formKey = GlobalKey();
    return _formKey;
  }

  FormModel({@required this.key});

  void addButton(
      {@required String text,
      @required Function onPressed,
      Color color,
      Color textColor,
      FormButtonType type = FormButtonType.raisedButton,
      Stream<bool> loadingStream = null}) {
    this._buttons.add(FormButton(text, onPressed,
        color: color, textColor: textColor, type: type));
    notifyListeners();
  }

  void addRowButton(
      {@required String text,
      @required Function onPressed,
      Color color,
      Color textColor,
      FormButtonType type = FormButtonType.raisedButton}) {
    this._buttons.add(FormButton(text, onPressed,
        color: color, textColor: textColor, type: type));
    notifyListeners();
  }

  void addField(
      {@required String fieldKey,
      @required String name,
      String initialValue,
      @required Function(String) validator,
      @required Function(String) onSave,
      bool obscureText = false,
      IconData icon,
      TextInputType inputType = TextInputType.text,
      TextAlign textAlign = TextAlign.left,
      TextInputAction inputAction = TextInputAction.next,
      TextCapitalization textCapitalization = TextCapitalization.none,
      TextStyle textStyle,
      bool autoCorrect = false,
      bool required = false,
      String regexPattern,
      String exampleValue}) {
    this._valueItems.add(ValueItem(fieldKey, ""));

    var thisFocusNode = FocusNode();
    var thisKey = GlobalKey<State>();

    var thisField = TextFormField(
      key: thisKey,
      focusNode: thisFocusNode,
      textAlign: TextAlign.center,
      initialValue: initialValue,

      textCapitalization: textCapitalization,
      autocorrect: autoCorrect,
      textInputAction: inputAction,
      decoration: InputDecoration(
        suffixIcon: icon != null ? Icon(icon) : null,
        labelText: name,

        //hintText: name == "email" ? "Email Address" : name,
        // hintStyle: TextStyle(color: Colors.whte),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        //border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.0)),
      ),
      keyboardType: inputType,

      style: textStyle,
      autofocus: false,
      validator: (String thisValue) {
        if (required && (thisValue == null || thisValue.isEmpty))
          return "please enter your $name";

        if (regexPattern != null && regexPattern.isNotEmpty) {
          RegExp expresion = RegExp(regexPattern);
          if (!expresion.hasMatch(thisValue))
            return "$name is not correct, please enter a valid value like $exampleValue";
        }

        if (validator != null) {
          return validator(thisValue);
        }
      },
      onSaved: onSave,
      obscureText: obscureText,
      onEditingComplete: () {
        print("editing completed...");
      },
    );

    this._fields.add(FocusField(
        focusNode: thisFocusNode, formField: thisField, fieldkey: thisKey));
    notifyListeners();
  }

  void setFieldValue(String key, String value) {
    print("setting field value: " + key);
    var thisField = this._valueItems.firstWhere((o) => o.key == key);
    if (thisField != null) {
      thisField.value = value;
      print("key: " + key + ", has value: " + value);
    } else
      print(key + " is null");
  }

  String getFieldValue(String key) {
    print("getting key value: " + key);
    var thisValue = _valueItems.any((ValueItem v) => v.key == key)
        ? _valueItems.firstWhere((o) => o.key == key)?.value
        : null;
    // print("getting key value: " + key + ", " + thisValue ?? "");
    return thisValue;
  }
}

class FormButton extends Model {
  String text;
  Function onPressed;
  Color color;
  Color textColor;
  bool isBusy;
  FormButtonType type;
  Widget buttonChild;
  Stream<bool> loadingStream;
  Widget button;

  FormButton(this.text, this.onPressed,
      {this.color,
      this.textColor,
      this.type = FormButtonType.raisedButton,
      this.loadingStream}) {
    isBusy = false;
  }

  void toggleState() {
    this.isBusy = !this.isBusy;
    notifyListeners();
  }

  Widget buildButton() {
    if (loadingStream != null) {
      loadingStream.listen((bool ondata) {
        isBusy = ondata;
        notifyListeners();
      });
    }

    this.button = RaisedButton(
      elevation: 5.0,
      child: isBusy
          ? CircularProgressIndicator()
          : Text(
              this.text,
              style: TextStyle(fontSize: 18.0),
            ),
      onPressed: isBusy ? null : this.onPressed,
      color: this.color,
      textColor: this.textColor,
    );

    return this.button;
  }
}

enum FormButtonType { raisedButton, progressButton }

class GenericFormState extends State<GenericForm> {
  bool _isBusy = false;

  void toggleIsBusy() {
    setState(() {
      _isBusy = !_isBusy;
    });
  }

  Widget _buildFields() {
    var thisColumn = Column(
      children: <Widget>[],
    );
    // print(widget._fields);
    widget.model.fields.forEach((FocusField f) {
      thisColumn.children.add(f.formField);
      thisColumn.children.add(SizedBox(
        height: 12.0,
      ));
    });

    return SingleChildScrollView(
      child: Container(child: thisColumn),
    );
  }

  Widget _buildButtons() {
    var thisRow = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[],
    );

    widget.model.buttons.forEach((FormButton button) {
      Widget thisButton;

      if (null != button.loadingStream)
        button.loadingStream.listen((bool data) {
          setState(() {
            print("something has changed...");
          });
        });

      thisButton = Container(
        height: 36.0,
        child: button.buildButton(),
      );

      thisRow.children.add(Expanded(
        child: Container(
          child: thisButton,
          margin: EdgeInsets.all(2.0),
        ),
      ));
    });

    return Container(child: thisRow);
  }

  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    double targetWidth = currentWidth > 768.0 ? 500 : currentWidth * 0.80;

    double currentHeight = MediaQuery.of(context).size.height;
    double maxHeight = currentHeight * 0.8;

    print(currentHeight);

    print(MediaQuery.of(context).size.height.toString());

    double targetHeight = 96;
    targetHeight += (widget.model.fields.length * 64);
    targetHeight += (widget.model.buttons.length * 54);
    targetHeight += 72;

    var children = <Widget>[];

    if (this.widget.formTitle != null && this.widget.formTitle.isNotEmpty) {
      children.add(DecoratedText(
        this.widget.formTitle,
        textColor: Colors.white,
        fontSize: 48.0,
        alignment: Alignment.center,
      ));
    }

    if (this.widget.subTitle != null && this.widget.subTitle.isNotEmpty) {
      children.add(DecoratedText(
        this.widget.subTitle,
        textColor: Colors.white,
        fontSize: 16.0,
        alignment: Alignment.center,
      ));
      children.add(SizedBox(
        height: 16.0,
      ));
    }

    children.add(_buildFields());
    children.add(_buildButtons());

    var thisScroller = ListView(
      children: children,
    );
    Widget thisContainer;

    var blurContainer = Container(
      height: (targetHeight >= maxHeight) ? maxHeight : targetHeight,
      padding: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor.withOpacity(0.45),
          borderRadius: BorderRadius.circular(12.0)),
      child: thisScroller,
    );

    thisContainer = AnimatedContainer(
      margin: EdgeInsets.only(top: 0.0),
      alignment: Alignment.center,
      width: targetWidth,
      height: targetHeight,
      decoration: BoxDecoration(
        color: (widget.blur ?? false) ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: (widget.blur ?? false) ? blurContainer : thisScroller,
      duration: Duration(milliseconds: 500),
    );

    return Form(
      key: widget.model.formKey,
      child: Container(
        alignment: Alignment.center,
        // margin: EdgeInsets.only(top: 25.0),

        child: thisContainer,
      ),
    );
  }
}
