import 'package:json_annotation/json_annotation.dart';

part 'user_token_model.g.dart';

@JsonSerializable()
class UserTokenModel {
  @JsonKey(name: 'username')
  String? username;
  @JsonKey(name: 'user_token')
  String? accessToken;
  @JsonKey(name: 'salt')
  String? salt;
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'verify_code')
  String? verifyCode;

  @JsonKey(name: 'uid')
  int? uid;

  @JsonKey(name: 'expiry_ts')
  int? epxToken;

  UserTokenModel();

  factory UserTokenModel.fromJson(Map<String, dynamic> json) =>
      _$UserTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserTokenModelToJson(this);
}
