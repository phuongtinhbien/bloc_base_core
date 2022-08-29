// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTokenModel _$UserTokenModelFromJson(Map<String, dynamic> json) =>
    UserTokenModel()
      ..username = json['username'] as String?
      ..accessToken = json['user_token'] as String?
      ..salt = json['salt'] as String?
      ..email = json['email'] as String?
      ..verifyCode = json['verify_code'] as String?
      ..uid = json['uid'] as int?
      ..epxToken = json['expiry_ts'] as int?;

Map<String, dynamic> _$UserTokenModelToJson(UserTokenModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'user_token': instance.accessToken,
      'salt': instance.salt,
      'email': instance.email,
      'verify_code': instance.verifyCode,
      'uid': instance.uid,
      'expiry_ts': instance.epxToken,
    };
