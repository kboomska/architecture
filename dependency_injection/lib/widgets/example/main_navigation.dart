import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:dependency_injection/widgets/app/my_app.dart';

abstract class MainNavigationRouteNames {
  static const example = '/';
}

abstract class ScreenFactory {
  Widget makeExampleScreen();
}

class MainNavigationDefault implements MainNavigation {
  final screenFactory = GetIt.instance<ScreenFactory>();

  @override
  Map<String, Widget Function(BuildContext)> makeRoutes() =>
      <String, Widget Function(BuildContext)>{
        MainNavigationRouteNames.example: (_) =>
            screenFactory.makeExampleScreen(),
      };

  @override
  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(
          builder: (_) => widget,
        );
    }
  }
}
