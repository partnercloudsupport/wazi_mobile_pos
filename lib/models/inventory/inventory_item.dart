import 'package:json_annotation/json_annotation.dart';

/// This allows the `UserModel` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'inventory_item.g.dart';

@JsonSerializable()
class InventoryItem {
  String id, documentId, productId, createdBy;
  int quantity;
  double cost;

  InventoryItem(
      {this.id,
      this.documentId,
      this.productId,
      this.createdBy,
      this.quantity,
      this.cost});

  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryItemToJson(this);
}
