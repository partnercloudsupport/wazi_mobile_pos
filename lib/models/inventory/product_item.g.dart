// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductItem _$ProductItemFromJson(Map<String, dynamic> json) {
  return ProductItem(
      id: json['id'] as String,
      documentId: json['documentId'] as String,
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      description: json['description'] as String,
      merchantId: json['merchantId'] as String,
      createdBy: json['createdBy'] as String,
      sellingprice: (json['sellingprice'] as num)?.toDouble(),
      images: (json['images'] as List)?.map((e) => e as String)?.toList(),
      createDate: json['createDate'] == null
          ? null
          : DateTime.parse(json['createDate'] as String));
}

Map<String, dynamic> _$ProductItemToJson(ProductItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'documentId': instance.documentId,
      'categoryId': instance.categoryId,
      'name': instance.name,
      'displayName': instance.displayName,
      'description': instance.description,
      'merchantId': instance.merchantId,
      'createdBy': instance.createdBy,
      'sellingprice': instance.sellingprice,
      'images': instance.images,
      'createDate': instance.createDate?.toIso8601String()
    };
