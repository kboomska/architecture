import 'package:shared_preferences/shared_preferences.dart';

import 'package:bloc_counter/domain/entity/user.dart';

class UserDataProvider {
  final _sharedPreferences = SharedPreferences.getInstance();

  Future<User> loadValue() async {
    final age = (await _sharedPreferences).getInt('age') ?? 0;
    return User(age);
  }

  Future<void> saveValue(User user) async {
    (await _sharedPreferences).setInt('age', user.age);
  }
}
