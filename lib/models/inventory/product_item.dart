import 'package:json_annotation/json_annotation.dart';
import 'dart:typed_data';

/// This allows the `UserModel` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'product_item.g.dart';

@JsonSerializable()
class ProductItem {
  ProductItem(
      {this.id,
      this.documentId,
      this.categoryId,
      this.name,
      this.displayName,
      this.description,
      this.merchantId,
      this.createdBy,
      this.sellingprice,
      this.images,
      this.createDate});

  String id,
      documentId,
      categoryId,
      name,
      displayName,
      description,
      merchantId,
      createdBy;

  double sellingprice;

  List<String> images;

  DateTime createDate;

  factory ProductItem.fromJson(Map<String, dynamic> json) =>
      _$ProductItemFromJson(json);

  Map<String, dynamic> toJson() => _$ProductItemToJson(this);
}
