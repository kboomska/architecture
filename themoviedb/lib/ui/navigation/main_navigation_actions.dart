import 'package:flutter/material.dart';

import 'package:themoviedb/ui/navigation/main_navigation_route_names.dart';

class MainNavigationActions {
  const MainNavigationActions();

  void resetNavigation(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
        MainNavigationRouteNames.loader, (route) => false);
  }
}
