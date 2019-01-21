// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_favourite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientFavourite _$ClientFavouriteFromJson(Map<String, dynamic> json) {
  return ClientFavourite(
      id: json['id'],
      merchantId: json['merchantId'],
      customerId: json['customerId']);
}

Map<String, dynamic> _$ClientFavouriteToJson(ClientFavourite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'merchantId': instance.merchantId,
      'customerId': instance.customerId
    };
