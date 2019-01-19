import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `UserModel` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'user_model.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class UserModel {
  String id; //this is the id generted for the row on firestore
  String userId; //this is the userId allocated from firebase
  String name;
  String lastname;
  DateTime registeredDate;
  String merchantId;
  String phoneNumber;
  String email;
  UserRole role;
  String password;

  UserModel(
      {this.id,
      this.userId,
      @required this.name,
      @required this.lastname,
      @required this.registeredDate,
      @required this.role,
      @required this.phoneNumber,
      @required this.email,
      this.password});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

enum UserRole { owner, employee }
