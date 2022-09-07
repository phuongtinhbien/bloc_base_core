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

  /// > It reads the token from the storage and returns an instance of the
  /// AppTokenStorage class
  ///
  /// Args:
  ///   storage (AppStorage): The storage object that will be used to store the
  /// token.
  ///
  /// Returns:
  ///   A Future<AppTokenStorage>
  @factoryMethod
  static Future<AppTokenStorage> init(AppStorage storage) async {
    final token = await storage.read(StorageKey.userTokenData);
    if (token != null) {
      final mapToken = jsonDecode(token);
      return AppTokenStorage(UserTokenModel.fromJson(mapToken), storage);
    }
    return AppTokenStorage(null, storage);
  }

  /// > Delete the current token from the storage and set the current token to null
  @override
  Future<void> delete() async {
    _currToken = null;
    await appStorage.delete(StorageKey.userTokenData);
  }

  /// > Read the current token from the cache
  ///
  /// Returns:
  ///   The current token.
  @override
  Future<UserTokenModel?> read() async {
    return _currToken;
  }

 /// > It writes the token to the storage and updates the current token
  ///
  /// Args:
  ///   token (UserTokenModel): The token to be written.
   @override
  Future<void> write(UserTokenModel token) async {
    _currToken = token;

    await appStorage.write(StorageKey.userTokenData, jsonEncode(token));
  }
}
