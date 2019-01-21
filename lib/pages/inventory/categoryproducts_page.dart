import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wazi_mobile_pos/models/inventory/product_item.dart';

class CategoryProductsPage extends StatelessWidget {
  CategoryProductsPage({@required this.products, @required this.categoryName});

  final List<ProductItem> products;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        elevation: 5.0,
        centerTitle: true,
      ),
      body: _buildProductList(context),
    );
  }

  Widget _buildProductList(BuildContext context) {
    return ListView.builder(
      itemCount: (products.length),
      itemBuilder: (BuildContext context, int index) {
        var c = products[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(c.images[1]),
          ),
          title: Text("${c.displayName}"),
          subtitle: Text("${c.description}"),
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) =>
            //             ClientViewPage(c, state)));
          },
          trailing: CircleAvatar(
            child: Text(c.displayName.substring(0, 1).toUpperCase()),
          ),
        );
      },
    );
  }
}
