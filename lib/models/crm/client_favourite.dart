import 'package:json_annotation/json_annotation.dart';
import 'package:scoped_model/scoped_model.dart';


part 'client_favourite.g.dart';

@JsonSerializable()
class ClientFavourite extends Model {
  String id, merchantId, customerId;

  ClientFavourite({id, merchantId, customerId});


  factory ClientFavourite.fromJson(Map<String, dynamic> json) => _$ClientFavouriteFromJson(json);

  Map<String, dynamic> toJson() => _$ClientFavouriteToJson(this);
}
