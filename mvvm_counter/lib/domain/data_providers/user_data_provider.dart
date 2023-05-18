import 'package:shared_preferences/shared_preferences.dart';

import 'package:mvvm_counter/domain/entity/user.dart';

class UserDataProvider {
  final sharedPreferences = SharedPreferences.getInstance();

  User user = User(0);

  Future<void> loadValue() async {
    final age = (await sharedPreferences).getInt('age') ?? 0;
    user = User(age);
  }

  Future<void> saveValue() async {
    (await sharedPreferences).setInt('age', user.age);
  }
}
