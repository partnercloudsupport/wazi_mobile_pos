import 'package:wazi_mobile_pos/common/service_base.dart';
import 'package:wazi_mobile_pos/models/product.dart';

mixin ProductService on ServiceBase {
  List<Product> _products = [];

  List<Product> get products {
    return List.from(_products);
  }

  void addProduct(Product thisProduct) {
    if (!this.hasProduct(thisProduct.id)) this._products.add(thisProduct);
  }

  void deleteProduct(Product thisProduct) {
    if (!this.hasProduct(thisProduct.id)) {
      this.products.removeWhere((Product oo) => oo.id == thisProduct.id);
    }
  }

  void updateProduct(Product thisProduct) {
    if (!this.hasProduct(thisProduct.id)) {
      int thisIndex =
          this.products.indexWhere((Product oo) => oo.id == thisProduct.id);
      if (thisIndex == null)
        this.addProduct(thisProduct);
      else
        _products[thisIndex] = thisProduct;
    }
  }

  bool hasProduct(String id) {
    if (id.isEmpty) return false;
    return this._products.any((Product oo) => oo.id == id);
  }
}
