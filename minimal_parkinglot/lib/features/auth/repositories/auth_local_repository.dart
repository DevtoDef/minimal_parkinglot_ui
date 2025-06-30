import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minimal_parkinglot/core/providers/storage_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(Ref ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  if (sharedPreferences.hasValue) {
    return AuthLocalRepository(sharedPreferences.value!);
  } else {
    throw Exception('SharedPreferences not initialized');
  }
}

class AuthLocalRepository {
  final SharedPreferences _sharedPreferences;
  AuthLocalRepository(this._sharedPreferences);

  Future<void> setToken(String? token) async {
    if (token != null) {
      await _sharedPreferences.setString('x-auth-token', token);
    }
  }

  String? getToken() {
    return _sharedPreferences.getString('x-auth-token');
  }

  // Clear the token from local storage
  Future<void> clearToken() async {
    await _sharedPreferences.remove('x-auth-token');
  }
}
