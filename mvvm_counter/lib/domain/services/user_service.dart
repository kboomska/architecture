import 'package:flutter/material.dart';

import 'package:mvvm_counter/domain/data_providers/user_data_provider.dart';
import 'package:mvvm_counter/domain/entity/user.dart';

typedef UserServiceOnUpdate = void Function(User);

class UserService {
  final _userDataProvider = UserDataProvider();

  VoidCallback? _currentOnUpdate;

  void startListenUser(UserServiceOnUpdate onUpdate) {
    void currentOnUpdate() {
      onUpdate(_userDataProvider.user);
    }

    _currentOnUpdate = currentOnUpdate;
    _userDataProvider.addListener(currentOnUpdate);
    onUpdate(_userDataProvider.user);
    _userDataProvider.openConnect();
  }

  void stopListenUser() {
    final currentOnUpdate = _currentOnUpdate;
    if (currentOnUpdate != null) {
      _userDataProvider.removeListener(currentOnUpdate);
    }
  }
}
