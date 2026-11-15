import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/user_profile.dart';
import '../domain/repositories/profile_repository.dart';
import 'user_profile_json.dart';

class LocalProfileRepository implements ProfileRepository {
  LocalProfileRepository({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const String _key = 'user_profile';
  static const int _schemaVersion = 1;

  final SharedPreferencesAsync _preferences;

  @override
  Future<UserProfile> load() async {
    final stored = await _preferences.getString(_key);
    if (stored == null) {
      return UserProfile.empty;
    }

    try {
      if (jsonDecode(stored) case final Map json) {
        return userProfileFromJson(json.cast<String, Object?>());
      }
    } on FormatException {
      // Texto corrompido: segue com o perfil vazio, sem apagar o que há.
    }
    return UserProfile.empty;
  }

  @override
  Future<void> save(UserProfile profile) async {
    final json = {'schema_version': _schemaVersion, ...profile.toJson()};
    await _preferences.setString(_key, jsonEncode(json));
  }
}
