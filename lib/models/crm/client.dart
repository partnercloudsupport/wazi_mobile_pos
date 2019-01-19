import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wazi_mobile_pos/models/crm/item_value.dart';

/// This allows the `UserModel` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'client.g.dart';

@JsonSerializable()
class Client {
  Client({
    this.givenName,
    this.middleName,
    this.prefix,
    this.suffix,
    this.familyName,
    this.company,
    this.jobTitle,
    this.emails,
    this.phones,
    this.avatar,
  });

  String identifier,
      displayName,
      givenName,
      middleName,
      prefix,
      suffix,
      familyName,
      company,
      jobTitle;

  List<String> emails = [];
  List<String> phones = [];
  Uint8List avatar;

  Client.fromMap(Map m) {
    identifier = m["identifier"];
    displayName = m["displayName"];
    givenName = m["givenName"];
    middleName = m["middleName"];
    familyName = m["familyName"];
    prefix = m["prefix"];
    suffix = m["suffix"];
    company = m["company"];
    jobTitle = m["jobTitle"];
    avatar = m["avatar"];
  }

  Client.fromContact(Contact c) {
    identifier = c.identifier;
    displayName = c.displayName;
    givenName = c.givenName;
    middleName = c.middleName;
    familyName = c.familyName;
    prefix = c.prefix;
    suffix = c.suffix;
    company = c.company;
    jobTitle = c.jobTitle;
    avatar = c.avatar;
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ClientToJson(this);
}
