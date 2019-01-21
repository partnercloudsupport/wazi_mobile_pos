import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';


part 'firebase_object.g.dart';

@JsonSerializable()
class FirebaseObject {
  String id, fullpath, downloadUrl, storageBucket, type;

  FirebaseObject({id, fullpath, downloadUrl, storageBucket, type});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory FirebaseObject.fromJson(Map<String, dynamic> json) =>
      _$FirebaseObjectFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$FirebaseObjectToJson(this);

}