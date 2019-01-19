import 'package:json_annotation/json_annotation.dart';

part 'item_value.g.dart';

@JsonSerializable()
class ItemValue {
  ItemValue({this.label, this.value});
  String label, value;

  ItemValue.fromMap(Map m) {
    label = m["label"];
    value = m["value"];
  }

  static Map toMap(ItemValue i) => {"label": i.label, "value": i.value};


   /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory ItemValue.fromJson(Map<String, dynamic> json) =>
      _$ItemValueFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ItemValueToJson(this);
}
