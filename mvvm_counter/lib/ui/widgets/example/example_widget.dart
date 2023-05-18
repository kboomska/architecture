import 'dart:math';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int age;

  User(this.age);

  User copyWith({
    int? age,
  }) {
    return User(
      age ?? this.age,
    );
  }
}

class UserService {
  User _user = User(0);
  User get user => _user;

  Future<void> loadValue() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final age = sharedPreferences.getInt('age') ?? 0;
    _user = User(age);
  }

  Future<void> saveValue() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('age', _user.age);
  }

  void incrementAge() {
    _user = _user.copyWith(age: _user.age + 1);
  }

  void decrementAge() {
    _user = _user.copyWith(age: max(_user.age - 1, 0));
  }
}

class ViewModelState {
  final String ageTitle;

  ViewModelState({
    required this.ageTitle,
  });
}

class ViewModel extends ChangeNotifier {
  final _userService = UserService();
  ViewModelState _state = ViewModelState(ageTitle: '');
  ViewModelState get state => _state;

  ViewModel() {
    loadValue();
  }

  Future<void> loadValue() async {
    await _userService.loadValue();
    _state = ViewModelState(
      ageTitle: _userService.user.age.toString(),
    );
    notifyListeners();
  }

  Future<void> onIncrementButtonPressed() async {
    _userService.incrementAge();
    _state = ViewModelState(
      ageTitle: _userService.user.age.toString(),
    );
    notifyListeners();
  }

  Future<void> onDecrementButtonPressed() async {
    _userService.decrementAge();
    _state = ViewModelState(
      ageTitle: _userService.user.age.toString(),
    );
    notifyListeners();
  }
}

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _AgeDecrementWidget(),
              _AgeTitle(),
              _AgeIncrementWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgeTitle extends StatelessWidget {
  const _AgeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final title =
        context.select((ViewModel viewModel) => viewModel.state.ageTitle);

    return SizedBox(
      width: 60,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _AgeIncrementWidget extends StatelessWidget {
  const _AgeIncrementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ViewModel>();

    return ElevatedButton(
      onPressed: viewModel.onIncrementButtonPressed,
      child: const Text('+'),
    );
  }
}

class _AgeDecrementWidget extends StatelessWidget {
  const _AgeDecrementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ViewModel>();

    return ElevatedButton(
      onPressed: viewModel.onDecrementButtonPressed,
      child: const Text('-'),
    );
  }
}
