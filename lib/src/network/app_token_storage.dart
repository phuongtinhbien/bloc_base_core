import 'dart:convert';

import 'package:bloc_base_core/src/data/constants/storage_key.dart';
import 'package:bloc_base_core/src/data/data_sources/app_storage.dart';
import 'package:bloc_base_core/src/data/models/user_token_model.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:injectable/injectable.dart';

class AppTokenStorage extends TokenStorage<UserTokenModel> {
  final AppStorage appStorage;
  UserTokenModel? _currToken;

  AppTokenStorage(this._currToken, this.appStorage);

  @factoryMethod
  static Future<AppTokenStorage> init(AppStorage storage) async {
    final token = await storage.read(StorageKey.userTokenData);
    if (token != null) {
      final mapToken = jsonDecode(token);
      return AppTokenStorage(UserTokenModel.fromJson(mapToken), storage);
    }
    return AppTokenStorage(null, storage);
  }

  @override
  Future<void> delete() async {
    _currToken = null;
    await appStorage.delete(StorageKey.userTokenData);
  }

  @override
  Future<UserTokenModel?> read() async {
    return _currToken;
  }

  @override
  Future<void> write(UserTokenModel token) async {
    _currToken = token;

    await appStorage.write(StorageKey.userTokenData, jsonEncode(token));
  }
}
