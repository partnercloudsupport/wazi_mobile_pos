import 'package:meta/meta.dart';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'transaction_item.g.dart';

@JsonSerializable()
class TransactionItem {
  String id, documentId, customerId, merchantId, userId;
  PaymentMethod paymentMethod;
  double amount;
  int itemCount;
  DateTime transactionDate;

  TransactionItem(
      {this.id,
      this.documentId,
      this.customerId,
      this.merchantId,
      this.userId,
      this.paymentMethod,
      this.amount,
      this.itemCount,
      this.transactionDate});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory TransactionItem.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$TransactionItemToJson(this);
}

enum PaymentMethod { cash, mobilemoney, card }
