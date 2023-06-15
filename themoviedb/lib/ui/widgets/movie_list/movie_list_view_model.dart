import 'dart:async';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:themoviedb/ui/navigation/main_navigation_route_names.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import 'package:themoviedb/Library/localization_model_storage.dart';
import 'package:themoviedb/domain/entity/movie.dart';
import 'package:themoviedb/Library/paginator.dart';

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

abstract class MovieListViewModelMoviesProvider {
  Future<PopularMovieResponse> popularMovies(
    int page,
    String locale,
  );

  Future<PopularMovieResponse> searchMovies(
    int page,
    String locale,
    String query,
  );
}

class MovieListViewModel extends ChangeNotifier {
  final MovieListViewModelMoviesProvider moviesProvider;
  late final Paginator<Movie> _popularMoviePaginator;
  late final Paginator<Movie> _searchMoviePaginator;
  final _localeStorage = LocalizationModelStorage();
  Timer? searchDebounce;

  var _movies = <MovieListPreparedData>[];
  String? _searchQuery;
  bool get isSearchMode {
    final searchQuery = _searchQuery;
    return searchQuery != null && searchQuery.isNotEmpty;
  }

  List<MovieListPreparedData> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;

  MovieListViewModel(this.moviesProvider) {
    _popularMoviePaginator = Paginator<Movie>(
      (page) async {
        final result =
            await moviesProvider.popularMovies(page, _localeStorage.localeTag);
        return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPages: result.totalPages,
        );
      },
    );
    _searchMoviePaginator = Paginator<Movie>(
      (page) async {
        final result = await moviesProvider.searchMovies(
          page,
          _localeStorage.localeTag,
          _searchQuery ?? '',
        );
        return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPages: result.totalPages,
        );
      },
    );
  }

  Future<void> setupLocale(Locale locale) async {
    if (!_localeStorage.isLocaleUpdated(locale)) return;

    _dateFormat = DateFormat.yMMMMd(_localeStorage.localeTag);
    await _resetList();
  }

  Future<void> _resetList() async {
    await _popularMoviePaginator.reset();
    await _searchMoviePaginator.reset();
    _movies.clear();
    await _loadNextPage();
  }

  Future<void> _loadNextPage() async {
    if (isSearchMode) {
      await _searchMoviePaginator.loadNextPage();
      _movies = _searchMoviePaginator.data.map(_prepareMovieData).toList();
    } else {
      await _popularMoviePaginator.loadNextPage();
      _movies = _popularMoviePaginator.data.map(_prepareMovieData).toList();
    }
    notifyListeners();
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

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed(
      MainNavigationRouteNames.movieDetails,
      arguments: id,
    );
  }

  Future<void> searchMovie(String text) async {
    searchDebounce?.cancel();
    searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;

      _movies.clear();
      if (isSearchMode) {
        await _searchMoviePaginator.reset();
      }
      _loadNextPage();
    });
  }

  void showedMovieAtIndex(int index) {
    if (index < _movies.length - 1) return;
    _loadNextPage();
  }
}
