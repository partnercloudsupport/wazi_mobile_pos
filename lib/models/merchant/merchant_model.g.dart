// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MerchantModel _$MerchantModelFromJson(Map<String, dynamic> json) {
  return MerchantModel(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      merchantCode: json['merchantCode'] as String,
      name: json['name'] as String,
      tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
      primaryBusiness: json['primaryBusiness'] as String,
      operatingHours: json['operatingHours'] as String,
      location: json['location'] as String,
      storeImage: json['storeImage'] as String,
      contactDetails: json['contactDetails'] as String,
      description: json['description'] as String)
    ..createdDate = json['createdDate'] == null
        ? null
        : DateTime.parse(json['createdDate'] as String);
}

Map<String, dynamic> _$MerchantModelToJson(MerchantModel instance) =>
    <String, dynamic>{
      'createdDate': instance.createdDate?.toIso8601String(),
      'id': instance.id,
      'ownerId': instance.ownerId,
      'merchantCode': instance.merchantCode,
      'name': instance.name,
      'tags': instance.tags,
      'primaryBusiness': instance.primaryBusiness,
      'operatingHours': instance.operatingHours,
      'location': instance.location,
      'storeImage': instance.storeImage,
      'contactDetails': instance.contactDetails,
      'description': instance.description
    };
