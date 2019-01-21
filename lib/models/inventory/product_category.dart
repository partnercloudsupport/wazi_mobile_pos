import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:typed_data';

/// This allows the `UserModel` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'product_category.g.dart';

@JsonSerializable()
class ProductCategory {
  String id, name, description, documentId;
  DateTime createDate;
  ProductCategoryColor color;
  ProductCategoryType type;

  ProductCategory(
      {this.id,
      this.name,
      this.description,
      this.documentId,
      this.createDate,
      this.color,
      this.type});

  Color getColor(ProductCategoryColor categoryColor) {
    switch (categoryColor) {
      case ProductCategoryColor.grey:
        return Colors.grey;
        break;
      case ProductCategoryColor.green:
        return Colors.green;
        break;
      case ProductCategoryColor.lightgreen:
        return Colors.lightGreen;
        break;
      case ProductCategoryColor.red:
        return Colors.red;
        break;
      case ProductCategoryColor.orange:
        return Colors.orange;
        break;
      case ProductCategoryColor.pink:
        return Colors.pink;
        break;
      case ProductCategoryColor.blue:
        return Colors.blue;
        break;
      case ProductCategoryColor.yellow:
        return Colors.yellow;
        break;
    }

    return Colors.teal;
  }

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCategoryToJson(this);
}

enum ProductCategoryColor {
  grey,
  green,
  lightgreen,
  red,
  orange,
  pink,
  blue,
  yellow
}

enum ProductCategoryType { nonperishable, perishable }
