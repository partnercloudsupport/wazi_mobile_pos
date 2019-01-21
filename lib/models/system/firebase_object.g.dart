// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_object.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FirebaseObject _$FirebaseObjectFromJson(Map<String, dynamic> json) {
  return FirebaseObject(
      id: json['id'],
      fullpath: json['fullpath'],
      downloadUrl: json['downloadUrl'],
      storageBucket: json['storageBucket'],
      type: json['type']);
}

Map<String, dynamic> _$FirebaseObjectToJson(FirebaseObject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullpath': instance.fullpath,
      'downloadUrl': instance.downloadUrl,
      'storageBucket': instance.storageBucket,
      'type': instance.type
    };
