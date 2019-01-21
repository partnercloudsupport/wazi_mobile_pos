import 'package:meta/meta.dart';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'cart_item.g.dart';

@JsonSerializable()
class CartItem {
  String id,
      shortdescription,
      documentId,
      productId,
      merchantId,
      userId,
      transactionId;
  double amount;
  CartItemType type;

  CartItem(
      {this.id,
      this.shortdescription,
      this.documentId,
      this.productId,
      this.merchantId,
      this.userId,
      this.transactionId,
      @required this.amount,
      @required this.type}) {
    if (this.id == null || this.id.isEmpty) this.id = Uuid().v4();
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}

enum CartItemType { productentry, cashentry }
