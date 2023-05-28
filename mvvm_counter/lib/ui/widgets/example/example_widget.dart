import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:mvvm_counter/ui/navigation/main_navigation.dart';
import 'package:mvvm_counter/domain/services/auth_service.dart';
import 'package:mvvm_counter/domain/services/user_service.dart';
import 'package:mvvm_counter/domain/entity/user.dart';

class _ViewModelState {
  final String ageTitle;

  _ViewModelState({
    required this.ageTitle,
  });
}

class _ViewModel extends ChangeNotifier {
  final _userService = UserService();
  final _authService = AuthService();

  _ViewModelState _state = _ViewModelState(ageTitle: '');
  _ViewModelState get state => _state;
  StreamSubscription<User>? userSubscription;

  _ViewModel() {
    _state = _ViewModelState(
      ageTitle: _userService.user.age.toString(),
    );
    userSubscription = _userService.userStream.listen((user) {
      _state = _ViewModelState(
        ageTitle: _userService.user.age.toString(),
      );
      notifyListeners();
    });
    _userService.openConnect();
  }

  Future<void> onLogoutButtonPressed(BuildContext context) async {
    await _authService.logout();
    if (context.mounted) MainNavigation.showLoader(context);
  }

  @override
  void dispose() {
    userSubscription?.cancel();
    _userService.closeConnect();
    super.dispose();
  }
}

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const ExampleWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Укажите возраст'),
        centerTitle: true,
        actions: [
          IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () => viewModel.onLogoutButtonPressed(context),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: const SafeArea(
        child: Center(
          child: _AgeTitle(),
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
        context.select((_ViewModel viewModel) => viewModel.state.ageTitle);

    return SizedBox(
      width: 60,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    );
  }
}
