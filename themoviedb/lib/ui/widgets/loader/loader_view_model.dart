import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class LoaderViewModel {
  final _sessionDataProvider = SessionDataProvider();
  final BuildContext context;

  LoaderViewModel(this.context) {
    asyncInit();
  }

  Future<void> asyncInit() async {
    await chechAuth();
  }

  Future<void> chechAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final isAuth = sessionId != null;
    final nextScreen = isAuth
        ? MainNavigationRouteNames.mainScreen
        : MainNavigationRouteNames.auth;

    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(nextScreen);
    }
  }
}
