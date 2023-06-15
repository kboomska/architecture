import 'package:flutter/material.dart';

import 'package:themoviedb/ui/navigation/main_navigation_route_names.dart';
import 'package:themoviedb/domain/factories/screen_factory.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';

class MainNavigation implements MyAppNavigation {
  final _screenFactory = const ScreenFactory();

  const MainNavigation();

  @override
  Map<String, Widget Function(BuildContext)> get routes => {
        MainNavigationRouteNames.loader: (_) => _screenFactory.makeLoader(),
        MainNavigationRouteNames.auth: (_) => _screenFactory.makeAuth(),
        MainNavigationRouteNames.mainScreen: (_) =>
            _screenFactory.makeMainScreen(),
      };

  @override
  Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.movieDetails:
        final arguments = settings.arguments;
        final movieId = arguments is int ? arguments : 0;
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeMovieDetails(movieId),
        );
      case MainNavigationRouteNames.movieTrailer:
        final arguments = settings.arguments;
        final youtubeKey = arguments is String ? arguments : '';
        return MaterialPageRoute(
          builder: (_) => _screenFactory.makeMovieTrailer(youtubeKey),
        );
      default:
        const widget = Text('Navigation error!!!');
        return MaterialPageRoute(
          builder: (_) => widget,
        );
    }
  }
}
