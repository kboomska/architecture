import 'package:flutter/material.dart';

abstract class MainNavigation {
  Map<String, Widget Function(BuildContext)> makeRoutes();
  Route<Object> onGenerateRoute(RouteSettings settings);
}

class MyApp extends StatelessWidget {
  final MainNavigation mainNavigation;

  const MyApp({super.key, required this.mainNavigation});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dependency Injection',
      debugShowCheckedModeBanner: false,
      routes: mainNavigation.makeRoutes(),
      onGenerateRoute: mainNavigation.onGenerateRoute,
    );
  }
}
