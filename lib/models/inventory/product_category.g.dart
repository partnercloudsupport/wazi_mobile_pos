// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCategory _$ProductCategoryFromJson(Map<String, dynamic> json) {
  return ProductCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      documentId: json['documentId'] as String,
      createDate: json['createDate'] == null
          ? null
          : DateTime.parse(json['createDate'] as String),
      color: _$enumDecodeNullable(_$ProductCategoryColorEnumMap, json['color']),
      type: _$enumDecodeNullable(_$ProductCategoryTypeEnumMap, json['type']));
}

Map<String, dynamic> _$ProductCategoryToJson(ProductCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'documentId': instance.documentId,
      'createDate': instance.createDate?.toIso8601String(),
      'color': _$ProductCategoryColorEnumMap[instance.color],
      'type': _$ProductCategoryTypeEnumMap[instance.type]
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

const _$ProductCategoryColorEnumMap = <ProductCategoryColor, dynamic>{
  ProductCategoryColor.grey: 'grey',
  ProductCategoryColor.green: 'green',
  ProductCategoryColor.lightgreen: 'lightgreen',
  ProductCategoryColor.red: 'red',
  ProductCategoryColor.orange: 'orange',
  ProductCategoryColor.pink: 'pink',
  ProductCategoryColor.blue: 'blue',
  ProductCategoryColor.yellow: 'yellow'
};

const _$ProductCategoryTypeEnumMap = <ProductCategoryType, dynamic>{
  ProductCategoryType.nonperishable: 'nonperishable',
  ProductCategoryType.perishable: 'perishable'
};
