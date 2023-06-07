import 'package:flutter/material.dart';

import 'package:dependency_injection/factories/service_locator.dart';
import 'package:dependency_injection/widgets/app/my_app.dart';

abstract class MainNavigationRouteNames {
  static const example = '/';
}

class MainNavigationDefault implements MainNavigation {
  @override
  Map<String, Widget Function(BuildContext)> makeRoutes() =>
      <String, Widget Function(BuildContext)>{
        MainNavigationRouteNames.example: (_) =>
            ServiceLocator.instance.makeExampleScreen(),
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
