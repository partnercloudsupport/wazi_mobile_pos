// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) {
  return Client(
      givenName: json['givenName'] as String,
      middleName: json['middleName'] as String,
      prefix: json['prefix'] as String,
      suffix: json['suffix'] as String,
      familyName: json['familyName'] as String,
      company: json['company'] as String,
      jobTitle: json['jobTitle'] as String,
      emails: (json['emails'] as List)?.map((e) => e as String)?.toList(),
      phones: (json['phones'] as List)?.map((e) => e as String)?.toList(),
      avatar: (json['avatar'] as List)?.map((e) => e as int)?.toList(),
      merchantId: json['merchantId'] as String,
      isFavorite: json['isFavorite'] as bool,
      createDate: json['createDate'] == null
          ? null
          : DateTime.parse(json['createDate'] as String),
      documentID: json['documentID'] as String)
    ..identifier = json['identifier'] as String
    ..displayName = json['displayName'] as String
    ..images = (json['images'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'identifier': instance.identifier,
      'displayName': instance.displayName,
      'givenName': instance.givenName,
      'middleName': instance.middleName,
      'prefix': instance.prefix,
      'suffix': instance.suffix,
      'familyName': instance.familyName,
      'company': instance.company,
      'jobTitle': instance.jobTitle,
      'merchantId': instance.merchantId,
      'documentID': instance.documentID,
      'isFavorite': instance.isFavorite,
      'createDate': instance.createDate?.toIso8601String(),
      'emails': instance.emails,
      'phones': instance.phones,
      'images': instance.images,
      'avatar': instance.avatar
    };
