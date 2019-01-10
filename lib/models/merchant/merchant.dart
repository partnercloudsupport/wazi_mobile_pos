import 'package:flutter/material.dart';
import 'package:wazi_mobile_pos/common/model_base.dart';

class Merchant extends ModelBase {
  final String id;
  final String merchantCode;
  final String name;
  final List<String> tags;
  final String primaryBusiness;
  final String operatingHours;
  final String location;
  final String storeImage;
  final String contactDetails;
  final String description;

  Merchant(
      {@required this.id,
      @required this.merchantCode,
      @required this.name,
      @required this.tags,
      @required this.primaryBusiness,
      @required this.operatingHours,
      @required this.location,
      @required this.storeImage,
      @required this.contactDetails,
      this.description});
}
