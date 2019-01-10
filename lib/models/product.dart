import 'package:flutter/material.dart';
import 'package:wazi_mobile_pos/common/model_base.dart';

class Product extends ModelBase {
  String id;
  String name;
  String description;
  String category;

  Product(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.category});
}
