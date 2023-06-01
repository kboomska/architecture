import 'dart:async';

import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import 'package:bloc_tmdb/domain/api_client/api_client_exception.dart';
import 'package:bloc_tmdb/ui/navigation/main_navigation.dart';
import 'package:bloc_tmdb/domain/services/auth_service.dart';
import 'package:bloc_tmdb/domain/blocs/auth_bloc.dart';

abstract class AuthViewCubitState {}

class AuthViewCubitFormFillInProgressState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitFormFillInProgressState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubitErrorState extends AuthViewCubitState {
  final String errorMessage;

  AuthViewCubitErrorState(this.errorMessage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitErrorState &&
          runtimeType == other.runtimeType &&
          other.errorMessage == errorMessage;

  @override
  int get hashCode => errorMessage.hashCode;
}

class AuthViewCubitAuthProgressState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitAuthProgressState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubitSuccessAuthState extends AuthViewCubitState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthViewCubitSuccessAuthState &&
          runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class AuthViewCubit extends Cubit<AuthViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authSubscription;

  AuthViewCubit(
    super.initialState,
    this.authBloc,
  ) {
    _onState(authBloc.state);
    authSubscription = authBloc.stream.listen(_onState);
  }

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  void auth({required String login, required String password}) {
    if (!_isValid(login, password)) {
      final state = AuthViewCubitErrorState('Заполните логин и пароль');
      emit(state);
      return;
    }

    authBloc.add(AuthLoginEvent(login: login, password: password));
  }

  void _onState(AuthState state) {
    if (state is AuthNotAuthorizedState) {
      emit(AuthViewCubitFormFillInProgressState());
    } else if (state is AuthAuthorizedState) {
      emit(AuthViewCubitSuccessAuthState());
    } else if (state is AuthFailureState) {
      final message = _mapErrorToMessage(state.error);
      emit(AuthViewCubitErrorState(message));
    } else if (state is AuthInProgressState) {
      emit(AuthViewCubitAuthProgressState());
    } else if (state is AuthCheckInProgressState) {
      emit(AuthViewCubitAuthProgressState());
    }
  }

  String _mapErrorToMessage(Object error) {
    if (error is! ApiClientException) {
      return 'Неизвестная ошибка, повторите попытку';
    }
    switch (error.type) {
      case ApiClientExceptionType.network:
        return 'Сервер не доступен. Проверьте подключение к сети интернет';
      case ApiClientExceptionType.auth:
        return 'Неправильныый логин или пароль!';
      case ApiClientExceptionType.sessionExpired:
      case ApiClientExceptionType.other:
        return 'Произошла ошибка. Попробуйте еще раз';
    }
  }

  @override
  Future<void> close() {
    authSubscription.cancel();
    return super.close();
  }
}

class AuthViewModel extends ChangeNotifier {
  final _authService = AuthService();

  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  Future<String?> _login(String login, String password) async {
    try {
      await _authService.login(login, password);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          return 'Сервер не доступен. Проверьте подключение к сети интернет';
        case ApiClientExceptionType.auth:
          return 'Неправильныый логин или пароль!';
        case ApiClientExceptionType.other:
          return 'Произошла ошибка. Попробуйте еще раз';
        default:
          break;
      }
    } catch (e) {
      return 'Неизвестная ошибка, повторите попытку';
    }
    return null;
  }

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;

    if (!_isValid(login, password)) {
      _updateState('Заполните логин и пароль', false);
      return;
    }

    _updateState(null, true);

    _errorMessage = await _login(login, password);
    if (_errorMessage == null) {
      if (context.mounted) {
        MainNavigation.resetNavigation(context);
      }
    } else {
      _updateState(_errorMessage, false);
    }
  }

  void _updateState(String? errorMessage, bool isAuthProgress) {
    if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
      return;
    }
    _errorMessage = errorMessage;
    _isAuthProgress = isAuthProgress;
    notifyListeners();
  }
}
