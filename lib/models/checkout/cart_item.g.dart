// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  return CartItem(
      id: json['id'] as String,
      shortdescription: json['shortdescription'] as String,
      documentId: json['documentId'] as String,
      productId: json['productId'] as String,
      merchantId: json['merchantId'] as String,
      userId: json['userId'] as String,
      transactionId: json['transactionId'] as String,
      amount: (json['amount'] as num)?.toDouble(),
      type: _$enumDecodeNullable(_$CartItemTypeEnumMap, json['type']));
}

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'id': instance.id,
      'shortdescription': instance.shortdescription,
      'documentId': instance.documentId,
      'productId': instance.productId,
      'merchantId': instance.merchantId,
      'userId': instance.userId,
      'transactionId': instance.transactionId,
      'amount': instance.amount,
      'type': _$CartItemTypeEnumMap[instance.type]
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$CartItemTypeEnumMap = <CartItemType, dynamic>{
  CartItemType.productentry: 'productentry',
  CartItemType.cashentry: 'cashentry'
};
