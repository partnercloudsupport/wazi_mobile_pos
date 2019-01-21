import 'package:wazi_mobile_pos/models/checkout/cart_item.dart';
import 'package:wazi_mobile_pos/common/service_base.dart';

mixin ShoppingCartService on ServiceBase {
  List<CartItem> _items;

  List<CartItem> get cartItems {
    return List.from(_items ?? []);
  }

  int get cartItemCount {
    return _items == null ? 0 : _items.length;
  }

  double get cartValue {
    if (_items == null || _items.length == 0) return 0.00;

    var result = 0.0;
    _items.forEach((i) => result += i.amount);
    return result;
  }

  void addItemToCart(CartItem item) {
    if (null == _items) _items = [];
    _items.add(item);

    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    if (null == _items || item == null) return;

    this._items.removeWhere((i) => i.id == item.id);

    notifyListeners();
  }

  void clearShoppingCart() {
    if (null == _items) _items = [];
    _items.clear();

    notifyListeners();
  }
}
