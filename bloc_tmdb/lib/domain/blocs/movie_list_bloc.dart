import 'package:flutter/foundation.dart';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:bloc/bloc.dart';

import 'package:bloc_tmdb/domain/entity/popular_movie_response.dart';
import 'package:bloc_tmdb/domain/api_client/movie_api_client.dart';
import 'package:bloc_tmdb/configuration/configuration.dart';
import 'package:bloc_tmdb/domain/entity/movie.dart';

abstract class MovieListEvent {}

class MovieListLoadNextPageEvent extends MovieListEvent {
  final String locale;

  MovieListLoadNextPageEvent(this.locale);
}

class MovieListResetEvent extends MovieListEvent {}

class MovieListSearchMovieEvent extends MovieListEvent {
  final String query;

  MovieListSearchMovieEvent(this.query);
}

class MovieListContainer {
  final List<Movie> movies;
  final int currentPage;
  final int totalPage;

  bool get isComplete => currentPage >= totalPage;

  MovieListContainer({
    required this.movies,
    required this.currentPage,
    required this.totalPage,
  });

  const MovieListContainer.initial()
      : movies = const <Movie>[],
        currentPage = 0,
        totalPage = 1;

  MovieListContainer copyWith({
    List<Movie>? movies,
    int? currentPage,
    int? totalPage,
  }) {
    return MovieListContainer(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieListContainer &&
          other.runtimeType == runtimeType &&
          listEquals(other.movies, movies) &&
          other.currentPage == currentPage &&
          other.totalPage == totalPage;

  @override
  int get hashCode =>
      movies.hashCode ^ currentPage.hashCode ^ totalPage.hashCode;
}

class MovieListState {
  final MovieListContainer popularMovieContainer;
  final MovieListContainer searchMovieContainer;
  final String searchQuery;

  bool get isSearchMode => searchQuery.isNotEmpty;

  MovieListState({
    required this.popularMovieContainer,
    required this.searchMovieContainer,
    required this.searchQuery,
  });

  const MovieListState.initial()
      : popularMovieContainer = const MovieListContainer.initial(),
        searchMovieContainer = const MovieListContainer.initial(),
        searchQuery = '';

  MovieListState copyWith({
    MovieListContainer? popularMovieContainer,
    MovieListContainer? searchMovieContainer,
    String? searchQuery,
  }) {
    return MovieListState(
      popularMovieContainer:
          popularMovieContainer ?? this.popularMovieContainer,
      searchMovieContainer: searchMovieContainer ?? this.searchMovieContainer,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieListState &&
          other.runtimeType == runtimeType &&
          other.popularMovieContainer == popularMovieContainer &&
          other.searchMovieContainer == searchMovieContainer &&
          other.searchQuery == searchQuery;

  @override
  int get hashCode =>
      popularMovieContainer.hashCode ^
      searchMovieContainer.hashCode ^
      searchQuery.hashCode;
}

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final _movieApiClient = MovieApiClient();

  MovieListBloc(super.initialState) {
    on<MovieListEvent>(
      (event, emit) async {
        if (event is MovieListLoadNextPageEvent) {
          await onMovieListLoadNextPageEvent(event, emit);
        } else if (event is MovieListResetEvent) {
          await onMovieListResetEvent(event, emit);
        } else if (event is MovieListSearchMovieEvent) {
          await onMovieListSearchMovieEvent(event, emit);
        }
      },
      transformer: sequential(),
    );
  }

  Future<void> onMovieListLoadNextPageEvent(
    MovieListLoadNextPageEvent event,
    Emitter<MovieListState> emit,
  ) async {
    if (state.isSearchMode) {
      final newContainer = await _loadNextPage(
        state.searchMovieContainer,
        (nextPage) async {
          final result = await _movieApiClient.searchMovies(
            nextPage,
            event.locale,
            state.searchQuery,
            Configuration.apiKey,
          );
          return result;
        },
      );
      if (newContainer != null) {
        final newState = state.copyWith(searchMovieContainer: newContainer);
        emit(newState);
      }
    } else {
      final newContainer = await _loadNextPage(
        state.popularMovieContainer,
        (nextPage) async {
          final result = await _movieApiClient.popularMovies(
            nextPage,
            event.locale,
            Configuration.apiKey,
          );
          return result;
        },
      );
      if (newContainer != null) {
        final newState = state.copyWith(popularMovieContainer: newContainer);
        emit(newState);
      }
    }
  }

  Future<MovieListContainer?> _loadNextPage(
    MovieListContainer movieListContainer,
    Future<PopularMovieResponse> Function(int) loader,
  ) async {
    if (movieListContainer.isComplete) return null;
    final nextPage = movieListContainer.currentPage + 1;
    final result = await loader(nextPage);
    final movies = movieListContainer.movies;
    movies.addAll(result.movies);

    final newContainer = movieListContainer.copyWith(
      movies: movies,
      currentPage: result.page,
      totalPage: result.totalPages,
    );
    return newContainer;
  }

  Future<void> onMovieListResetEvent(
    MovieListResetEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(const MovieListState.initial());
  }

  Future<void> onMovieListSearchMovieEvent(
    MovieListSearchMovieEvent event,
    Emitter<MovieListState> emit,
  ) async {
    if (state.searchQuery == event.query) return;
    final newState = state.copyWith(
      searchQuery: event.query,
      searchMovieContainer: const MovieListContainer.initial(),
    );
    emit(newState);
  }
}
