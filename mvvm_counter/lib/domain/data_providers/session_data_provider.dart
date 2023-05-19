import 'package:shared_preferences/shared_preferences.dart';

abstract class SessionDataProviderKeys {
  static const _apiKey = 'api_key';
}

class SessionDataProvider {
  final _sharedPreferences = SharedPreferences.getInstance();

  Future<String?> getApiKey() async {
    return (await _sharedPreferences)
        .getString(SessionDataProviderKeys._apiKey);
  }

  Future<void> setApiKey(String key) async {
    (await _sharedPreferences).setString(SessionDataProviderKeys._apiKey, key);
  }
}
