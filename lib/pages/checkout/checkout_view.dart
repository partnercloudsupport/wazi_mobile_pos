import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/models/checkout/cart_item.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/tools/textformatter.dart';
import 'package:wazi_mobile_pos/widgets/general/text_tag.dart';

class CheckoutView extends StatefulWidget {
  @override
  CheckoutViewState createState() {
    return new CheckoutViewState();
  }
}

class CheckoutViewState extends State<CheckoutView> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Viewing Cart"),
          ),
          body: _buildCheckoutView(context, state),
          bottomSheet: Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "# ${state.cartItemCount}",
                  style: TextStyle(fontSize: 24.0),
                ),
                Text("${TextFormatter.toStringCurrency(state.cartValue)}",
                    style: TextStyle(fontSize: 24.0))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckoutView(BuildContext context, AppState state) {
    if (state.cartItems == null || state.cartItems.length == 0) {
      return Center(
        child: Text("There are currently no items in your cart"),
      );
    } else {
      return _buildCartItems(context, state.cartItems, state);
    }
  }

  Widget _buildCartItems(
      BuildContext context, List<CartItem> items, AppState state) {
    return SingleChildScrollView(
      child: Container(
        height: (MediaQuery.of(context).size.height / 4) * 2,
        child: ListView.builder(
          itemCount: (items.length),
          itemBuilder: (BuildContext context, int index) {
            var c = items[index];
            return Dismissible(
              background: Container(
                color: Colors.red,
                child: Center(
                  child: Text(
                    "Delete",
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (DismissDirection direction) {
                setState(() {
                  if (direction == DismissDirection.endToStart) {
                    state.removeFromCart(c);
                  }
                });
              },
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.attach_money),
                ),
                title: Text("${c.shortdescription}"),
                subtitle: Text("${c.type.toString()}"),
                trailing: TextTag(
                  displayText: TextFormatter.toStringCurrency(c.amount),
                ),
              ),
              key: Key("${c.id}"),
            );
          },
        ),
      ),
    );
  }
}
