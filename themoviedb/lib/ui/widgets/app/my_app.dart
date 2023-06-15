import 'package:flutter/material.dart';

import 'package:themoviedb/ui/navigation/main_navigation_route_names.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:themoviedb/ui/theme/app_colors.dart';

abstract class MyAppNavigation {
  Map<String, Widget Function(BuildContext)> get routes;
  Route<Object> onGenerateRoute(RouteSettings settings);
}

class MyApp extends StatelessWidget {
  final MyAppNavigation navigation;

  const MyApp({
    super.key,
    required this.navigation,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TMDB',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.mainDarkBlue,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.mainDarkBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        // Locale('en'),
        Locale('ru', 'RU'),
      ],
      routes: navigation.routes,
      initialRoute: MainNavigationRouteNames.loader,
      onGenerateRoute: navigation.onGenerateRoute,
    );
  }
}
