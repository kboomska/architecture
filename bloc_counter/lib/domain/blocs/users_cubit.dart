import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';

import 'package:bloc_counter/domain/data_providers/user_data_provider.dart';
import 'package:bloc_counter/domain/entity/user.dart';

class UsersState {
  final User currentUser;

  UsersState({
    required this.currentUser,
  });

  UsersState copyWith({
    User? currentUser,
  }) {
    return UsersState(
      currentUser: currentUser ?? this.currentUser,
    );
  }

  @override
  String toString() => 'UsersState(currentUser: $currentUser)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UsersState && other.currentUser == currentUser;
  }

  @override
  int get hashCode => currentUser.hashCode;
}

class UsersCubit extends Cubit<UsersState> {
  final _userDataProvider = UserDataProvider();

  UsersCubit() : super(UsersState(currentUser: User(0))) {
    _initialize();
  }

  Future<void> _initialize() async {
    final user = await _userDataProvider.loadValue();
    final newState = state.copyWith(currentUser: user);
    emit(newState);
  }

  void incrementAge() {
    var user = state.currentUser;
    user = user.copyWith(age: user.age + 1);
    emit(state.copyWith(currentUser: user));
    _userDataProvider.saveValue(user);
  }

  void decrementAge() {
    var user = state.currentUser;
    user = user.copyWith(age: max(user.age - 1, 0));
    emit(state.copyWith(currentUser: user));
    _userDataProvider.saveValue(user);
  }
}
