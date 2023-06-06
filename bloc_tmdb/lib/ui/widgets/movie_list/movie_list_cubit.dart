import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';

import 'package:bloc_tmdb/domain/blocs/movie_list_bloc.dart';
import 'package:bloc_tmdb/domain/entity/movie.dart';

class MovieListPreparedData {
  final int id;
  final String? posterPath;
  final String title;
  final String releaseDate;
  final String overview;

  MovieListPreparedData({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.releaseDate,
    required this.overview,
  });
}

class MovieListCubitState {
  List<MovieListPreparedData> movies;
  final String localeTag;

  MovieListCubitState({
    required this.movies,
    required this.localeTag,
  });

  MovieListCubitState copyWith({
    List<MovieListPreparedData>? movies,
    String? localeTag,
    String? searchQuery,
  }) {
    return MovieListCubitState(
      movies: movies ?? this.movies,
      localeTag: localeTag ?? this.localeTag,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MovieListCubitState &&
        listEquals(other.movies, movies) &&
        other.localeTag == localeTag;
  }

  @override
  int get hashCode => movies.hashCode ^ localeTag.hashCode;
}

class MovieListCubit extends Cubit<MovieListCubitState> {
  final MovieListBloc movieListBloc;
  late final StreamSubscription<MovieListState> movieListBlocSubscription;
  late DateFormat _dateFormat;
  Timer? searchDebounce;

  MovieListCubit({required this.movieListBloc})
      : super(
          MovieListCubitState(
            movies: const <MovieListPreparedData>[],
            localeTag: '',
          ),
        ) {
    Future.microtask(
      () {
        _onState(movieListBloc.state);
        movieListBlocSubscription = movieListBloc.stream.listen(_onState);
      },
    );
  }

  void _onState(MovieListState state) {
    final movies = state.movies.map(_prepareMovieData).toList();
    final newState = this.state.copyWith(movies: movies);
    emit(newState);
  }

  void setupLocale(String localeTag) {
    if (state.localeTag == localeTag) return;
    final newState = state.copyWith(localeTag: localeTag);
    emit(newState);
    _dateFormat = DateFormat.yMMMMd(localeTag);
    movieListBloc.add(MovieListResetEvent());
    movieListBloc.add(MovieListLoadNextPageEvent(localeTag));
  }

  void showedMovieAtIndex(int index) {
    if (index < state.movies.length - 1) return;
    movieListBloc.add(MovieListLoadNextPageEvent(state.localeTag));
  }

  void searchMovie(String text) {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      movieListBloc.add(MovieListSearchMovieEvent(text));
      movieListBloc.add(MovieListLoadNextPageEvent(state.localeTag));
    });
  }

  MovieListPreparedData _prepareMovieData(Movie movie) {
    final date = movie.releaseDate;
    final releaseDate = date != null ? _dateFormat.format(date) : '';
    return MovieListPreparedData(
      posterPath: movie.posterPath,
      id: movie.id,
      title: movie.title,
      releaseDate: releaseDate,
      overview: movie.overview,
    );
  }

  @override
  Future<void> close() {
    movieListBlocSubscription.cancel();
    return super.close();
  }
}
