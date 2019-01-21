import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/models/crm/client.dart';
import 'package:wazi_mobile_pos/models/inventory/product_category.dart';
import 'package:wazi_mobile_pos/models/inventory/product_item.dart';
import 'package:wazi_mobile_pos/pages/crm/clientadd_page.dart';
import 'package:wazi_mobile_pos/pages/inventory/categoryadd_page.dart';
import 'package:wazi_mobile_pos/pages/inventory/categoryproducts_page.dart';
import 'package:wazi_mobile_pos/pages/inventory/productadd_page.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/tools/textformatter.dart';
import 'package:wazi_mobile_pos/widgets/core/main_drawer.dart';
import 'package:wazi_mobile_pos/widgets/crm/client_list.dart';
import 'package:wazi_mobile_pos/widgets/general/text_tag.dart';

class InventoryPage extends StatefulWidget {
  final AppState initialState;

  const InventoryPage({Key key, this.initialState}) : super(key: key);

  @override
  InventoryPageState createState() {
    return new InventoryPageState();
  }
}

class InventoryPageState extends State<InventoryPage> {
  @override
  void initState() {
    super.initState();
    widget.initialState?.customerService?.loadCustomers(widget.initialState);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState state) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
                title: Text("Inventory"),
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 5.0,
                centerTitle: true,
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.category),
                      text: "Categories",
                    ),
                    Tab(
                      icon: Icon(Icons.image),
                      text: "Products",
                    ),
                  ],
                )),
            drawer: MainDrawer(
              startingIndex: 2,
            ),
            body: TabBarView(
              children: <Widget>[
                _getCategoryList(context, state),
                _getProductList(context, state)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getProductList(BuildContext context, AppState state) {
    return FutureBuilder(
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductItem>> snapshot) {
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
                print("displaying products...");
                return _buildProductList(context, state, snapshot);
              } else {
                return new ListView(children: <Widget>[
                  new Text("sorry my friend you have no customers..")
                ]);
              }
            }
        }
      },
      future: state.inventoryService.loadProducts(state),
    );
  }

  Widget _getCategoryList(BuildContext context, AppState state) {
    return FutureBuilder(
      builder: (BuildContext context,
          AsyncSnapshot<List<ProductCategory>> snapshot) {
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
                return _buildCategoryGrid(context, state, snapshot);
              } else {
                return new ListView(children: <Widget>[
                  new Text("sorry my friend you have no customers..")
                ]);
              }
            }
        }
      },
      future: state.inventoryService.loadCategories(state),
    );
  }

  Widget _buildProductList(BuildContext context, AppState state,
      AsyncSnapshot<List<ProductItem>> snapshot) {
    // var currentOrientation = MediaQuery.of(context).orientation;
    if (!snapshot.hasData) {
      print("no product data");
    }

    return ListView.builder(
      itemCount: (snapshot.data.length + 1),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.add),
            ),
            title: Text("Add Product"),
            subtitle: Text("tap to add a new product"),
            onTap: () {
              _loadCategories(state).then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProductAddPage(
                          state: state,
                          categories: value,
                        ),
                  ),
                );
              });
            },
            trailing: CircleAvatar(
              child: Text("N"),
            ),
          );
        } else {
          var c = snapshot.data[index - 1];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: File(c.images[2]).existsSync()
                  ? FileImage(File(c.images[2]))
                  : NetworkImage(c.images[1]),
            ),
            title: Text("${c.displayName}"),
            subtitle: Row(
              children: <Widget>[
                Text("${c.description}"),
              ],
            ),
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) =>
              //             ClientViewPage(c, state)));
            },
            trailing: TextTag(
              displayText: TextFormatter.toStringCurrency(c.sellingprice),
            ),
          );
        }
      },
    );
  }

  Future<List<Map<String, String>>> _loadCategories(AppState state) async {
    List<Map<String, String>> result = [];

    var categories = await state.inventoryService.loadCategories(state);
    if (null != categories) {
      categories.forEach((ProductCategory p) {
        result.add({"id": p.id, "name": p.name});
      });
    }

    return result;
  }

  Widget _buildCategoryGrid(BuildContext context, AppState state,
      AsyncSnapshot<List<ProductCategory>> snapshot) {
    print("grid width");
    print(MediaQuery.of(context).size.width.toString());

    if (!snapshot.hasData)
      return Text("you have no categories, please add some...");
    else {
      return GridView.builder(
        itemCount: snapshot.data.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            //first card must be a new addition
            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return CategoryAddPage(
                    state: state,
                  );
                }));
              },
              child: Card(
                elevation: 5.0,
                child: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).accentColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "New Category",
                        style: TextStyle(color: Colors.white, fontSize: 24.0),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        minRadius: 36.0,
                        maxRadius: 36.0,
                        child: Icon(
                          Icons.add,
                          size: 48.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            var c = snapshot.data[index - 1];
            return GestureDetector(
              onTap: () {
                _loadCategoryProducts(state, c).then((filteredProducts) {
                  if (filteredProducts != null && filteredProducts.length > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return CategoryProductsPage(
                          categoryName: c.name,
                          products: filteredProducts,
                        );
                      }),
                    );
                  }
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
          }
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 360 ? 4 : 2),
      );
    }
  }

  Future<List<ProductItem>> _loadCategoryProducts(
      AppState state, ProductCategory category) async {
    return await state.inventoryService
        .getProductsByCategory(state, category.id);
  }
}
