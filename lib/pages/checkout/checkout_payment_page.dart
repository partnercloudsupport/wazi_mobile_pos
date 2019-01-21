import 'package:flutter/material.dart';
import 'package:wazi_mobile_pos/models/checkout/cart_item.dart';
import 'package:wazi_mobile_pos/models/checkout/transaction_item.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/tools/textformatter.dart';

class CheckoutPaymentPage extends StatefulWidget {
  final AppState state;
  final List<CartItem> items;

  const CheckoutPaymentPage(
      {Key key, @required this.state, @required this.items})
      : super(key: key);

  @override
  CheckoutPaymentPageState createState() {
    return new CheckoutPaymentPageState();
  }
}

class CheckoutPaymentPageState extends State<CheckoutPaymentPage> {
  Future<bool> _submitPayment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recieve Payment"),
        centerTitle: true,
      ),
      body: _buildFutureControl(context),
    );
  }

  Widget _buildFutureControl(BuildContext context) {
    return FutureBuilder<bool>(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return _buildCheckoutDisplay(context, widget.state);
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          case ConnectionState.active:
            return new Text('it is active and loaded');
          case ConnectionState.done:
            if (snapshot.hasError) {
              return new Text(
                '${snapshot.error}',
                style: TextStyle(color: Colors.red),
              );
            } else {
              if (snapshot.hasData) {
                return _buildPaymentSuccessPage(context);
              } else {
                return new ListView(children: <Widget>[
                  new Text("sorry my friend you have no customers..")
                ]);
              }
            }
        }
      },
      future: _submitPayment,
    );
  }

  Widget _buildCheckoutDisplay(BuildContext context, AppState state) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height / 3.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${TextFormatter.toStringCurrency(state.cartValue)}",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 48.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Please selected payment type below",
                    style: TextStyle(color: Colors.grey, fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Divider(),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 52.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: RaisedButton(
                      elevation: 5.0,
                      color: Colors.teal,
                      child: Text("Cash",
                          style: TextStyle(
                              fontFamily: "Oswald",
                              color: Colors.white,
                              fontSize: 16.0)),
                      onPressed: () {
                        _submitPayment =
                            _completePayment(state, PaymentMethod.cash);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 52.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: RaisedButton(
                      elevation: 5.0,
                      color: Colors.blue,
                      child: Text("Mobile Money",
                          style: TextStyle(
                              fontFamily: "Oswald",
                              color: Colors.white,
                              fontSize: 16.0)),
                      onPressed: () {
                        _submitPayment =
                            _completePayment(state, PaymentMethod.mobilemoney);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 52.0,
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: RaisedButton(
                      elevation: 5.0,
                      color: Colors.pink,
                      child: Text("Card",
                          style: TextStyle(
                              fontFamily: "Oswald",
                              color: Colors.white,
                              fontSize: 16.0)),
                      onPressed: () {
                        _submitPayment =
                            _completePayment(state, PaymentMethod.card);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSuccessPage(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Transaction completed successfully!",
            style: TextStyle(fontSize: 36.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            "please tap on the circle to continue",
            style: TextStyle(fontSize: 14.0),
          ),
          SizedBox(
            height: 8.0,
          ),
          CircleAvatar(
            minRadius: 64.0,
            backgroundColor: Theme.of(context).primaryColor,
            child: IconButton(
              icon: Icon(Icons.check),
              iconSize: 64.0,
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
              splashColor: Theme.of(context).accentColor,
            ),
          )
        ],
      ),
      duration: Duration(seconds: 3),
    );
  }

  Future<bool> _completePayment(
      AppState state, PaymentMethod paymentMethod) async {
    var result = await state.transactionService
        .submitTransaction(widget.items, state, paymentMethod: paymentMethod);

    setState(() {
      state.clearShoppingCart();
    });

    return result;
  }
}
