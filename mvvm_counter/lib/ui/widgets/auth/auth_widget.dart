import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:mvvm_counter/domain/data_providers/auth_api_provider.dart';
import 'package:mvvm_counter/ui/navigation/main_navigation.dart';
import 'package:mvvm_counter/domain/services/auth_service.dart';

enum _ViewModelAuthButtonState { canSubmit, isAuthProcess, disable }

class _ViewModelState {
  String authErrorTitle = '';
  String login = '';
  String password = '';
  bool isAuthProcess = false;

  _ViewModelAuthButtonState get authButtonState {
    if (isAuthProcess) {
      return _ViewModelAuthButtonState.isAuthProcess;
    } else if (login.isNotEmpty && password.isNotEmpty) {
      return _ViewModelAuthButtonState.canSubmit;
    } else {
      return _ViewModelAuthButtonState.disable;
    }
  }
}

class _ViewModel extends ChangeNotifier {
  final _authService = AuthService();
  final _state = _ViewModelState();
  _ViewModelState get state => _state;

  void login(String value) {
    if (_state.login == value) return;
    _state.login = value;
    notifyListeners();
  }

  void password(String value) {
    if (_state.password == value) return;
    _state.password = value;
    notifyListeners();
  }

  Future<void> onAuthButtonPressed(BuildContext context) async {
    final login = _state.login;
    final password = _state.password;

    if (login.isEmpty || password.isEmpty) return;

    _state.authErrorTitle = '';
    _state.isAuthProcess = true;
    notifyListeners();

    try {
      await _authService.login(login, password);
      _state.isAuthProcess = false;
      notifyListeners();
      if (context.mounted) MainNavigation.showLoader(context);
    } on AuthApiProviderIncorrectLoginDataError {
      _state.authErrorTitle = 'Неправильный логин или пароль';
      _state.isAuthProcess = false;
      notifyListeners();
    } catch (exception) {
      _state.authErrorTitle = 'Произошла ошибка. Попробуйте ещё раз';
      _state.isAuthProcess = false;
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _ErrorTitleWidget(),
                SizedBox(
                  height: 10,
                ),
                _LoginWidget(),
                SizedBox(
                  height: 10,
                ),
                _PasswordWidget(),
                SizedBox(
                  height: 10,
                ),
                _AuthButtonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginWidget extends StatelessWidget {
  const _LoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();

    return TextField(
      decoration: const InputDecoration(
        labelText: 'Логин',
        border: OutlineInputBorder(),
      ),
      onChanged: model.login,
    );
  }
}

class _PasswordWidget extends StatelessWidget {
  const _PasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();

    return TextField(
      decoration: const InputDecoration(
        labelText: 'Пароль',
        border: OutlineInputBorder(),
      ),
      onChanged: model.password,
    );
  }
}

class _ErrorTitleWidget extends StatelessWidget {
  const _ErrorTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authErrorTitle =
        context.select((_ViewModel value) => value.state.authErrorTitle);

    return Text(authErrorTitle);
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final authButtonState =
        context.select((_ViewModel value) => value.state.authButtonState);
    final onPressed = authButtonState == _ViewModelAuthButtonState.canSubmit
        ? model.onAuthButtonPressed
        : null;
    final child = authButtonState == _ViewModelAuthButtonState.isAuthProcess
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        : const Text('Войти');

    return ElevatedButton(
      onPressed: () => onPressed?.call(context),
      child: child,
    );
  }
}
