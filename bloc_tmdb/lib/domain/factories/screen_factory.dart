import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'package:bloc_tmdb/ui/widgets/movie_details/movie_details_widget_model.dart';
import 'package:bloc_tmdb/ui/widgets/movie_trailer/movie_trailer_widget.dart';
import 'package:bloc_tmdb/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:bloc_tmdb/ui/widgets/tv_show_list/tv_show_list_widget.dart';
import 'package:bloc_tmdb/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:bloc_tmdb/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:bloc_tmdb/ui/widgets/movie_list/movie_list_cubit.dart';
import 'package:bloc_tmdb/ui/widgets/loader/loader_view_cubit.dart';
import 'package:bloc_tmdb/ui/widgets/auth/auth_view_cubit.dart';
import 'package:bloc_tmdb/ui/widgets/loader/loader_widget.dart';
import 'package:bloc_tmdb/domain/blocs/movie_list_bloc.dart';
import 'package:bloc_tmdb/ui/widgets/auth/auth_widget.dart';
import 'package:bloc_tmdb/ui/widgets/news/news_widget.dart';
import 'package:bloc_tmdb/domain/blocs/auth_bloc.dart';

class ScreenFactory {
  AuthBloc? _authBloc;

  Widget makeLoader() {
    final authBloc = _authBloc ?? AuthBloc(AuthCheckInProgressState());
    _authBloc = authBloc;
    return BlocProvider<LoaderViewCubit>(
      create: (_) => LoaderViewCubit(
        LoaderViewCubitState.unknown,
        authBloc,
      ),
      child: const LoaderWidget(),
    );
  }

  Widget makeAuth() {
    final authBloc = _authBloc ?? AuthBloc(AuthCheckInProgressState());
    _authBloc = authBloc;

    return BlocProvider<AuthViewCubit>(
      create: (_) => AuthViewCubit(
        AuthViewCubitFormFillInProgressState(),
        authBloc,
      ),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    _authBloc?.close();
    _authBloc = null;
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
    return BlocProvider<MovieListCubit>(
      create: (_) => MovieListCubit(
        movieListBloc: MovieListBloc(
          const MovieListState.initial(),
        ),
      ),
      child: const MovieListWidget(),
    );
  }

  Widget makeTVShowList() {
    return const TVShowListWidget();
  }
}
