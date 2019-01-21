import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/models/checkout/cart_item.dart';
import 'package:wazi_mobile_pos/models/inventory/product_category.dart';
import 'package:wazi_mobile_pos/models/inventory/product_item.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/tools/textformatter.dart';
import 'package:wazi_mobile_pos/widgets/general/text_tag.dart';

class CheckoutProductsWidget extends StatefulWidget {
  @override
  CheckoutProductsWidgetState createState() {
    return new CheckoutProductsWidgetState();
  }
}

class CheckoutProductsWidgetState extends State<CheckoutProductsWidget> {
  Future<List<ProductItem>> _productsFuture;
  final AsyncMemoizer<List<ProductCategory>> _categorymemoizer =
      AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState state) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              _buildCategorySlider(context, state),
              _buildProductSelection(context, state)
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySlider(BuildContext context, AppState state) {
    return FutureBuilder<List<ProductCategory>>(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('not started yet...');
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
                print("inventory being shown");
                return _getCategorySwiper(context, snapshot, state);
              } else {
                return new ListView(children: <Widget>[
                  new Text("sorry my friend you have no customers..")
                ]);
              }
            }
        }
      },
      future: this._categorymemoizer.runOnce(() async {
        return await state.inventoryService.loadCategories(state);
      }),
    );
  }

  Widget _getCategorySwiper(BuildContext context,
      AsyncSnapshot<List<ProductCategory>> snapshot, AppState state) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width,
      child: Swiper(
        layout: SwiperLayout.DEFAULT,
        viewportFraction: 0.8,
        scale: 0.9,
        itemCount: snapshot.data.length,
        itemHeight: MediaQuery.of(context).size.height / 3,
        pagination: SwiperPagination(),
        itemBuilder: (BuildContext context, int index) {
          var c = snapshot.data[index];
          return GestureDetector(
            onTap: () {
              //if this is tapped we must load the products below.
              setState(() {
                _productsFuture = state.inventoryService
                    .getProductsByCategory(state, snapshot.data[index].id);
              });
            },
            child: Card(
              elevation: 5.0,
              child: Container(
                alignment: Alignment.center,
                color: c.getColor(c.color),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${c.name.substring(0, 1).toUpperCase()}${c.name.substring(1, 2).toLowerCase()}",
                      style: TextStyle(color: Colors.white, fontSize: 24.0),
                    ),
                    Text(
                      "${c.name}",
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductSelection(BuildContext context, AppState state) {
    return FutureBuilder<List<ProductItem>>(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Center(
              child: Text("Please select a category"),
            );
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
                print("inventory being shown");
                return _getProductList(context, state, snapshot.data);
              } else {
                return new ListView(children: <Widget>[
                  new Text("sorry my friend you have no customers..")
                ]);
              }
            }
        }
      },
      future: _productsFuture,
    );
  }

  Widget _getProductList(
      BuildContext context, AppState state, List<ProductItem> products) {
    return SingleChildScrollView(
      child: Container(
        height: (MediaQuery.of(context).size.height / 4) * 2,
        child: ListView.builder(
          itemCount: (products.length),
          itemBuilder: (BuildContext context, int index) {
            var c = products[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: File(c.images[2]).existsSync()
                    ? FileImage(File(c.images[2]))
                    : NetworkImage(c.images[1]),
              ),
              title: Text("${c.displayName}"),
              subtitle: Text("${c.description}"),
              onTap: () {
                var cartItem = CartItem(
                    amount: c.sellingprice,
                    type: CartItemType.productentry,
                    shortdescription: c.name,
                    productId: c.id);

                state.addItemToCart(cartItem);

                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Entry added to cart",
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 1),
                ));
              },
              trailing: TextTag(
                displayText: TextFormatter.toStringCurrency(c.sellingprice),
              ),
            );
          },
        ),
      ),
    );
  }
}
