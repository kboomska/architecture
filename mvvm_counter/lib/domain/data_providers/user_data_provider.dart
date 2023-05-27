import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvvm_counter/domain/entity/user.dart';

class UserDataProvider extends ChangeNotifier {
  Timer? _timer;
  var _user = User(0);

  User get user => _user;

  void openConnect() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _user = User(_user.age + 1);
      notifyListeners();
    });
  }

  void closeConnect() {
    _timer?.cancel();
    _timer = null;
  }
}
