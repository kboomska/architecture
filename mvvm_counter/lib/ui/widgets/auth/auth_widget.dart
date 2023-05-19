import 'package:flutter/material.dart';
import 'package:mvvm_counter/domain/data_providers/auth_api_provider.dart';

import 'package:provider/provider.dart';

import 'package:mvvm_counter/domain/services/auth_service.dart';

class _ViewModelState {
  final String authErrorTitle;
  final String login;
  final String password;
  final bool canSubmit;
  final bool isAuthProcess;

  _ViewModelState({
    this.authErrorTitle = '',
    this.login = '',
    this.password = '',
    this.canSubmit = false,
    this.isAuthProcess = false,
  });

  _ViewModelState copyWith({
    String? authErrorTitle,
    String? login,
    String? password,
    bool? canSubmit,
    bool? isAuthProcess,
  }) {
    return _ViewModelState(
      authErrorTitle: authErrorTitle ?? this.authErrorTitle,
      login: login ?? this.login,
      password: password ?? this.password,
      canSubmit: canSubmit ?? this.canSubmit,
      isAuthProcess: isAuthProcess ?? this.isAuthProcess,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  final _authService = AuthService();
  _ViewModelState _state = _ViewModelState();
  _ViewModelState get state => _state;

  set login(String value) {
    if (_state.login == value) return;
    _state = _state.copyWith(login: value);
    notifyListeners();
  }

  set password(String value) {
    if (_state.password == value) return;
    _state = _state.copyWith(password: value);
    notifyListeners();
  }

  Future<void> auth() async {
    final login = _state.login;
    final password = _state.password;

    if (login.isEmpty || password.isEmpty) return;

    try {
      await _authService.login(login, password);
    } on AuthApiProviderIncorrectLoginDataError {
      _state =
          _state.copyWith(authErrorTitle: 'Не правильный логин или пароль');
      notifyListeners();
    } catch (exception) {
      _state.copyWith(authErrorTitle: 'Произошла ошибка. Попробуйте ещё раз');
      notifyListeners();
    }
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const AuthWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}
