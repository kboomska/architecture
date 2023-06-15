import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:themoviedb/ui/widgets/movie_details/movie_details_widget_model.dart';
import 'package:themoviedb/ui/widgets/movie_trailer/movie_trailer_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:themoviedb/ui/widgets/tv_show_list/tv_show_list_widget.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_view_model.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:themoviedb/ui/widgets/loader/loader_view_model.dart';
import 'package:themoviedb/ui/widgets/auth/auth_view_model.dart';
import 'package:themoviedb/ui/widgets/loader/loader_widget.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/auth/auth_widget.dart';
import 'package:themoviedb/ui/widgets/news/news_widget.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';
import 'package:themoviedb/main.dart';

AppFactory makeAppFactory() => const _AppFactoryDefault();

class _AppFactoryDefault implements AppFactory {
  final _diContainer = const _DIContainer();

  const _AppFactoryDefault();

  @override
  Widget makeApp() => MyApp(
        navigation: _diContainer.makeMyAppNavigation(),
      );
}

class _DIContainer {
  const _DIContainer();

  ScreenFactory makeScreenFactory() => const ScreenFactoryDefault();
  MyAppNavigation makeMyAppNavigation() => MainNavigation(makeScreenFactory());
}

class ScreenFactoryDefault implements ScreenFactory {
  const ScreenFactoryDefault();

  @override
  Widget makeLoader() {
    return Provider(
      lazy: false,
      create: (context) => LoaderViewModel(context),
      child: const LoaderWidget(),
    );
  }

  @override
  Widget makeAuth() {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const AuthWidget(),
    );
  }

  @override
  Widget makeMainScreen() {
    return const MainScreenWidget();
  }

  @override
  Widget makeMovieDetails(int movieId) {
    return ChangeNotifierProvider(
      create: (_) => MovieDetailsWidgetModel(movieId),
      child: const MovieDetailsWidget(),
    );
  }

  @override
  Widget makeMovieTrailer(String youtubeKey) {
    return MovieTrailerWidget(youtubeKey: youtubeKey);
  }

  @override
  Widget makeNewsList() {
    return const NewsWidget();
  }

  @override
  Widget makeMovieList() {
    return ChangeNotifierProvider(
      create: (_) => MovieListViewModel(),
      child: const MovieListWidget(),
    );
  }

  @override
  Widget makeTVShowList() {
    return const TVShowListWidget();
  }
}
