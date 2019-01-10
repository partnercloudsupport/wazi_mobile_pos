import 'package:flutter/material.dart';
import 'package:wazi_mobile_pos/widgets/general/value_item.dart';

class GenericForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  final List<Widget> _fields = [];
  final List<Widget> _buttons = [];
  final List<ValueItem> valueItems;

  GenericForm(this.formKey, this.valueItems);

  void setFieldValue(String key, String value) {
    print("setting field value: " + key);
    var thisField = valueItems.firstWhere((o) => o.key == key);
    if (thisField != null) {
      thisField.value = value;
      print("key: " + key + ", has value: " + value);
    } else
      print(key + " is null");
  }

  String getFieldValue(String key) {
    print("getting key value: " + key);
    var thisValue = valueItems.firstWhere((o) => o.key == key).value;
    print("getting key value: " + key + ", " + thisValue);
    return thisValue;
  }

  void addButton(
      {@required String text,
      @required Function onPressed,
      Color color,
      Color textColor}) {
    var thisButton = RaisedButton(
      child: Text(text),
      onPressed: onPressed,
      color: color,
      textColor: textColor,
    );

    this._buttons.add(thisButton);
  }

  void addField(
      {@required String fieldKey,
      @required String name,
      String initialValue,
      @required Function(String) validator,
      @required Function(String) onSave,
      bool obscureText = false,
      IconData icon,
      TextInputType inputType = TextInputType.text}) {
    this.valueItems.add(ValueItem(fieldKey, ""));

    var thisField = TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        suffixIcon: icon != null ? Icon(icon) : null,
        labelText: name,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      keyboardType: inputType,
      autofocus: false,
      validator: validator,
      onSaved: onSave,
      obscureText: obscureText,
    );

    this._fields.add(thisField);
    this._fields.add(SizedBox(
          height: 8.0,
        ));
  }

  @override
  GenericFormState createState() {
    return GenericFormState();
  }
}

class GenericFormState extends State<GenericForm> {
  Widget _buildFields() {
    var thisColumn = Column(
      children: <Widget>[],
    );
    // print(widget._fields);
    thisColumn.children.addAll(widget._fields);

    return thisColumn;
  }

  Widget _buildButtons() {
    var thisRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[],
    );
    // print(widget._buttons);
    thisRow.children.addAll(widget._buttons);

    return thisRow;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Container(
        alignment: Alignment.center,
        // margin: EdgeInsets.only(top: 25.0),
        child: SingleChildScrollView(
          child: AnimatedContainer(
            // width: this._targetWidth,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              children: <Widget>[
                _buildFields(),
                SizedBox(
                  height: 8.0,
                ),
                _buildButtons()
              ],
            ),
            duration: Duration(seconds: 3),
          ),
        ),
      ),
    );
  }
}
