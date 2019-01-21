import 'package:flutter/material.dart';
import 'package:wazi_mobile_pos/pages/checkout/calc_item.dart';

class KeypadWidget extends StatefulWidget {
  @override
  KeypadWidgetState createState() {
    return new KeypadWidgetState();
  }
}

class KeypadWidgetState extends State<KeypadWidget> {
  String _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildKeyPad(context),
      bottomSheet: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.monetization_on),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildKeyPad(BuildContext context) {
    var keypadoptions = _getKeyPadItems();

    return Container(
      child: Column(children: [
        _buildChargeButton(context),
        _buildRow(keypadoptions.take(3), context),
        _buildRow(keypadoptions.getRange(3, 6), context),
        _buildRow(keypadoptions.getRange(6, 9), context),
        _buildRow(keypadoptions.getRange(9, 12), context)
      ]),
    );
  }

  Widget _buildChargeButton(BuildContext context) {
    var chargeButton = Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        height: 64.0,
        child: RaisedButton(
          child: Text(
            "Charge",
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          color: Colors.blue,
          onPressed: () {},
        ),
      ),
    );

    return Row(
      children: <Widget>[chargeButton],
    );
  }

  Widget _buildRow(Iterable<CalcItem> keys, BuildContext context) {
    List<Widget> items = [];

    keys.forEach((k) {
      items.add(
        Expanded(
          flex: 3,
          child: Container(
            height: 64.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
            child: _buildKeyPadItem(k, context),
          ),
        ),
      );
    });

    return Row(children: items);
  }

  Widget _buildKeyPadItem(CalcItem key, BuildContext context) {
    return MaterialButton(
      child: key.type == CalcItemType.submit
          ? Icon(
              Icons.add,
              size: 24.0,
              color: Theme.of(context).primaryColor,
            )
          : Text(
              key.value,
              style: TextStyle(fontSize: 32.0),
            ),
      onPressed: () {
        switch (key.type) {
          case CalcItemType.normal:
            setState(() {
              _currentValue += key.value;
            });
            break;
          case CalcItemType.clear:
            setState(() {
              _currentValue = "";
            });
            break;
          case CalcItemType.submit:
            break;
        }
      },
    );
  }

  List<CalcItem> _getKeyPadItems() {
    return [
      CalcItem(order: 3, type: CalcItemType.normal, value: "1"),
      CalcItem(order: 4, type: CalcItemType.normal, value: "2"),
      CalcItem(order: 5, type: CalcItemType.normal, value: "3"),
      CalcItem(order: 6, type: CalcItemType.normal, value: "4"),
      CalcItem(order: 7, type: CalcItemType.normal, value: "5"),
      CalcItem(order: 8, type: CalcItemType.normal, value: "6"),
      CalcItem(order: 9, type: CalcItemType.normal, value: "7"),
      CalcItem(order: 9, type: CalcItemType.normal, value: "8"),
      CalcItem(order: 9, type: CalcItemType.normal, value: "9"),
      CalcItem(order: 2, type: CalcItemType.clear, value: "C"),
      CalcItem(order: 1, type: CalcItemType.normal, value: "0"),
      CalcItem(order: 0, type: CalcItemType.submit, value: "+")
    ];
  }
}
