// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) {
  return TransactionItem(
      id: json['id'] as String,
      documentId: json['documentId'] as String,
      customerId: json['customerId'] as String,
      merchantId: json['merchantId'] as String,
      userId: json['userId'] as String,
      paymentMethod:
          _$enumDecodeNullable(_$PaymentMethodEnumMap, json['paymentMethod']),
      amount: (json['amount'] as num)?.toDouble(),
      itemCount: json['itemCount'] as int,
      transactionDate: json['transactionDate'] == null
          ? null
          : DateTime.parse(json['transactionDate'] as String));
}

Map<String, dynamic> _$TransactionItemToJson(TransactionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentId': instance.documentId,
      'customerId': instance.customerId,
      'merchantId': instance.merchantId,
      'userId': instance.userId,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod],
      'amount': instance.amount,
      'itemCount': instance.itemCount,
      'transactionDate': instance.transactionDate?.toIso8601String()
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

const _$PaymentMethodEnumMap = <PaymentMethod, dynamic>{
  PaymentMethod.cash: 'cash',
  PaymentMethod.mobilemoney: 'mobilemoney',
  PaymentMethod.card: 'card'
};
