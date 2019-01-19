// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return UserModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      lastname: json['lastname'] as String,
      registeredDate: json['registeredDate'] == null
          ? null
          : DateTime.parse(json['registeredDate'] as String),
      role: _$enumDecodeNullable(_$UserRoleEnumMap, json['role']),
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      password: json['password'] as String)
    ..merchantId = json['merchantId'] as String;
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'lastname': instance.lastname,
      'registeredDate': instance.registeredDate?.toIso8601String(),
      'merchantId': instance.merchantId,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role],
      'password': instance.password
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$UserRoleEnumMap = <UserRole, dynamic>{
  UserRole.owner: 'owner',
  UserRole.employee: 'employee'
};
