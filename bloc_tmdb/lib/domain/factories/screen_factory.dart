import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:bloc_tmdb/ui/widgets/movie_details/movie_details_widget_model.dart';
import 'package:bloc_tmdb/ui/widgets/movie_trailer/movie_trailer_widget.dart';
import 'package:bloc_tmdb/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:bloc_tmdb/ui/widgets/tv_show_list/tv_show_list_widget.dart';
import 'package:bloc_tmdb/ui/widgets/movie_list/movie_list_view_model.dart';
import 'package:bloc_tmdb/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:bloc_tmdb/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:bloc_tmdb/ui/widgets/loader/loader_view_model.dart';
import 'package:bloc_tmdb/ui/widgets/auth/auth_view_model.dart';
import 'package:bloc_tmdb/ui/widgets/loader/loader_widget.dart';
import 'package:bloc_tmdb/ui/widgets/auth/auth_widget.dart';
import 'package:bloc_tmdb/ui/widgets/news/news_widget.dart';

class ScreenFactory {
  Widget makeLoader() {
    return Provider(
      lazy: false,
      create: (context) => LoaderViewModel(context),
      child: const LoaderWidget(),
    );
  }

  Widget makeAuth() {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    return const MainScreenWidget();
  }

  Widget makeMovieDetails(int movieId) {
    return ChangeNotifierProvider(
      create: (_) => MovieDetailsWidgetModel(movieId),
      child: const MovieDetailsWidget(),
    );
  }

  Widget makeMovieTrailer(String youtubeKey) {
    return MovieTrailerWidget(youtubeKey: youtubeKey);
  }

  Widget makeNewsList() {
    return const NewsWidget();
  }

  Widget makeMovieList() {
    return ChangeNotifierProvider(
      create: (_) => MovieListViewModel(),
      child: const MovieListWidget(),
    );
  }

  Widget makeTVShowList() {
    return const TVShowListWidget();
  }
}
