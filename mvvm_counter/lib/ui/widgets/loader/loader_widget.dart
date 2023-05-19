import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:mvvm_counter/domain/services/auth_service.dart';

class _ViewModel {
  final _authService = AuthService();
  BuildContext context;

  _ViewModel(this.context) {
    init();
  }

  void init() async {
    final isAuth = await _authService.checkAuth();
    if (isAuth) {
      _goToExampleScreen();
    } else {
      _goToAuthScreen();
    }
  }

  void _goToAuthScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      'auth',
      (route) => false,
    );
  }

  void _goToExampleScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      'example',
      (route) => false,
    );
  }
}

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  static Widget create() {
    return Provider(
      lazy: false,
      create: (context) => _ViewModel(context),
      child: const LoaderWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
