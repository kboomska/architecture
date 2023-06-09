import 'dart:math';

import 'package:bloc_concurrency/bloc_concurrency.dart';
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

abstract class UsersEvents {}

class UsersIncrementEvent implements UsersEvents {}

class UsersDecrementEvent implements UsersEvents {}

class UsersInitializeEvent implements UsersEvents {}

class UsersBloc extends Bloc<UsersEvents, UsersState> {
  final _userDataProvider = UserDataProvider();

  UsersBloc() : super(UsersState(currentUser: User(0))) {
    on<UsersEvents>(
      (event, emit) async {
        if (event is UsersInitializeEvent) {
          final user = await _userDataProvider.loadValue();
          emit(UsersState(currentUser: user));
        } else if (event is UsersIncrementEvent) {
          var user = state.currentUser;
          user = user.copyWith(age: user.age + 1);
          await _userDataProvider.saveValue(user);
          emit(UsersState(currentUser: user));
        } else if (event is UsersDecrementEvent) {
          var user = state.currentUser;
          user = user.copyWith(age: max(user.age - 1, 0));
          await _userDataProvider.saveValue(user);
          emit(UsersState(currentUser: user));
        }
      },
      transformer: sequential(),
    );
    add(UsersInitializeEvent());
  }
}
