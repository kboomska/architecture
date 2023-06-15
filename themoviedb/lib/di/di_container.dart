import 'package:flutter/material.dart';

import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';
import 'package:themoviedb/main.dart';

AppFactory makeAppFactory() => const _AppFactoryDefault();

class _AppFactoryDefault implements AppFactory {
  final _diContainer = const _DIContainer();

  const _AppFactoryDefault();

  @override
  Widget makeApp() => MyApp(
        navigation: _diContainer._mainNavigation,
      );
}

class _DIContainer {
  final MyAppNavigation _mainNavigation = const MainNavigation();

  const _DIContainer();
}
