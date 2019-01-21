import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/models/checkout/cart_item.dart';
import 'package:wazi_mobile_pos/pages/checkout/calc_item.dart';
import 'package:wazi_mobile_pos/pages/checkout/checkout_payment_page.dart';
import 'package:wazi_mobile_pos/pages/checkout/checkout_products_widget.dart';
import 'package:wazi_mobile_pos/pages/checkout/checkout_view.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/tools/textformatter.dart';
import 'package:wazi_mobile_pos/widgets/core/main_drawer.dart';

class CheckoutPage extends StatefulWidget {
  @override
  CheckoutPageState createState() {
    return new CheckoutPageState();
  }
}

class CheckoutPageState extends State<CheckoutPage> {
  String _currentValue;
  String _displayValue;
  String _currentHeading;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentHeading = "No items";
      _currentValue = "0";
      _displayValue = _currentValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState state) {
        return Scaffold(
          key: _scaffoldKey,
          body: _buildTabControl(context, state),
          appBar: (AppBar(
            centerTitle: true,
            title: Text("New Sale"),
          )),
          drawer: MainDrawer(
            startingIndex: 1,
          ),
        );
      },
    );
  }

  Widget _buildTabControl(BuildContext context, AppState state) {
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        body: TabBarView(
          children: [
            _buildKeyPad(context, state),
            CheckoutProductsWidget(),
            // CheckoutView()
          ],
        ),
        bottomNavigationBar: new TabBar(
          tabs: [
            Tab(
                icon: Icon(
              Icons.attach_money,
              color: Colors.grey,
            )),
            Tab(icon: Icon(Icons.add_shopping_cart, color: Colors.grey)),
            // Tab(icon: Icon(Icons.shopping_basket, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyPad(BuildContext context, AppState state) {
    return SingleChildScrollView(
      child: Container(
        child: Column(children: [
          _buildChargeButton(context, state),
          Divider(),
          _buildChargeText(context),
          Divider(),
          _buildnumpad(context, state)
        ]),
      ),
    );
  }

  Widget _buildnumpad(BuildContext context, AppState state) {
    var keypadoptions = _getKeyPadItems();

    return Container(
        child: Column(children: [
      _buildRow(keypadoptions.take(3), context, state),
      _buildRow(keypadoptions.getRange(3, 6), context, state),
      _buildRow(keypadoptions.getRange(6, 9), context, state),
      _buildRow(keypadoptions.getRange(9, 12), context, state)
    ]));
  }

  Widget _buildChargeButton(BuildContext context, AppState state) {
    var chargeButton = Expanded(
      flex: 2,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        height: 64.0,
        child: RaisedButton(
          child: Text(
            "Checkout",
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          color: Colors.blue,
          onPressed: () {
            if (state.cartItemCount > 0) {
              //CheckoutPaymentPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) {
                  return CheckoutPaymentPage(
                    state: state,
                    items: state.cartItems,
                  );
                }),
              );
            }
          },
        ),
      ),
    );

    var viewCartButton = Expanded(
      flex: 2,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        height: 64.0,
        child: RaisedButton(
          child: Text(
            "Show Cart",
            style: TextStyle(color: Colors.white, fontSize: 24.0),
          ),
          color: Colors.purple,
          onPressed: () {
            if (state.cartItemCount > 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    maintainState: true,
                    builder: (BuildContext context) {
                      return CheckoutView();
                    }),
              );
            }
          },
        ),
      ),
    );

    return Row(
      children: <Widget>[viewCartButton, chargeButton],
    );
  }

  Widget _buildChargeText(BuildContext context) {
    var chargeButton = Expanded(
      flex: 2,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        height: 64.0,
        child: Text(
          _displayValue,
          style: TextStyle(fontSize: 48.0, color: Colors.grey),
          textAlign: TextAlign.right,
        ),
      ),
    );

    return Row(
      children: <Widget>[chargeButton],
    );
  }

  Widget _buildRow(
      Iterable<CalcItem> keys, BuildContext context, AppState state) {
    List<Widget> items = [];
    var expectedHeight = (MediaQuery.of(context).size.height - 320);

    keys.forEach((k) {
      items.add(
        Expanded(
          flex: 3,
          child: Container(
            height: expectedHeight / 4,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
            child: _buildKeyPadItem(k, context, state),
          ),
        ),
      );
    });

    return Container(child: Row(children: items));
  }

  Widget _buildKeyPadItem(CalcItem key, BuildContext context, AppState state) {
    return MaterialButton(
      child: key.type == CalcItemType.submit
          ? Icon(
              Icons.add,
              size: 24.0,
              color: Theme.of(context).primaryColor,
            )
          : Text(
              key.value,
              style: TextStyle(fontSize: 32.0, color: Colors.grey),
            ),
      onPressed: () {
        switch (key.type) {
          case CalcItemType.normal:
            setState(() {
              _currentValue += key.value;
              _displayValue = TextFormatter.formatCurrency(
                  _currentValue.isEmpty ? "0" : _currentValue);
            });
            break;
          case CalcItemType.clear:
            setState(() {
              _currentValue = "";

              _displayValue = TextFormatter.formatCurrency(
                  _currentValue.isEmpty ? "0" : _currentValue);
            });
            break;
          case CalcItemType.submit:
            var amount = double.tryParse(_currentValue);

            if (amount == null || amount <= 0) return;

            CartItem cartItem = CartItem(
                amount: amount,
                type: CartItemType.cashentry,
                shortdescription: "Manual entry");

            state.addItemToCart(cartItem);
            // _scaffoldKey.currentState.showSnackBar(SnackBar(
            //   content: Text(
            //     "Entry added to cart",
            //     textAlign: TextAlign.center,
            //   ),
            //   duration: Duration(seconds: 1),
            // ));
            setState(() {
              _currentValue = "";

              _displayValue = TextFormatter.formatCurrency(
                  _currentValue.isEmpty ? "0" : _currentValue);

              _currentHeading = "${state.cartItemCount} items";
            });

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
