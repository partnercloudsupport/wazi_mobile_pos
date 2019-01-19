import 'package:flutter/material.dart';
import 'package:wazi_mobile_pos/common/model_base.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:wazi_mobile_pos/models/system/user_model.dart';

import 'package:uuid/uuid.dart';

/// This allows the `UserModel` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'merchant_model.g.dart';

@JsonSerializable()
class MerchantModel extends ModelBase {
  final String id;
  final String ownerId;
  final String merchantCode;
  final String name;
  final List<String> tags;
  final String primaryBusiness;
  final String operatingHours;
  final String location;
  final String storeImage;
  final String contactDetails;
  final String description;

  MerchantModel(
      {@required this.id,
      @required this.ownerId,
      @required this.merchantCode,
      @required this.name,
      @required this.tags,
      @required this.primaryBusiness,
      @required this.operatingHours,
      @required this.location,
      @required this.storeImage,
      @required this.contactDetails,
      this.description});

  //maps the initial details from the owner whom has just registered mostly
  factory MerchantModel.fromUser(UserModel owner) {
    return MerchantModel(
        ownerId: owner.id,
        id: Uuid().v1(),
        contactDetails: owner.phoneNumber,
        name: "${owner.name}'s Store",
        location: "Tanzania",
        merchantCode: Uuid().v4(),
        operatingHours: "8 - 5",
        primaryBusiness: "Unknown",
        storeImage: "assets/bg_portrait.jpg",
        tags: ["new business", owner.name],
        description: "${owner.name}'s most amazing business");
  }

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory MerchantModel.fromJson(Map<String, dynamic> json) =>
      _$MerchantModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$MerchantModelToJson(this);
}
