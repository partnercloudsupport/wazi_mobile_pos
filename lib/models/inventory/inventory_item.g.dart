// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) {
  return InventoryItem(
      id: json['id'] as String,
      documentId: json['documentId'] as String,
      productId: json['productId'] as String,
      createdBy: json['createdBy'] as String,
      quantity: json['quantity'] as int,
      cost: (json['cost'] as num)?.toDouble());
}

Map<String, dynamic> _$InventoryItemToJson(InventoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentId': instance.documentId,
      'productId': instance.productId,
      'createdBy': instance.createdBy,
      'quantity': instance.quantity,
      'cost': instance.cost
    };
