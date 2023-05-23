import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:themoviedb/domain/api_client/account_api_client.dart';
import 'package:themoviedb/domain/api_client/api_client_exception.dart';
import 'package:themoviedb/domain/api_client/movie_api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';
import 'package:themoviedb/domain/services/auth_service.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieDetailsPosterData {
  final String? backdropPath;
  final String? posterPath;
  final IconData favoriteIcon;

  MovieDetailsPosterData({
    this.backdropPath,
    this.posterPath,
    this.favoriteIcon = Icons.star_border,
  });
}

class MovieDetailsTitleData {
  final String title;
  final String year;

  MovieDetailsTitleData({
    required this.title,
    required this.year,
  });
}

class MovieDetailsData {
  String title = '';
  bool isLoading = true;
  String overview = '';
  MovieDetailsPosterData posterData = MovieDetailsPosterData();
  MovieDetailsTitleData titleData = MovieDetailsTitleData(title: '', year: '');
}

class MovieDetailsWidgetModel extends ChangeNotifier {
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();
  final _movieApiClient = MovieApiClient();
  final _authService = AuthService();

  final int movieId;
  final data = MovieDetailsData();
  String _locale = '';
  bool _isFavorite = false;
  MovieDetails? _movieDetails;
  late DateFormat _dateFormat;

  MovieDetailsWidgetModel(this.movieId);

  MovieDetails? get movieDetails => _movieDetails;

  bool get isFavorite => _isFavorite;

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();

    if (_locale == locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(_locale);
    updateData(null, false);
    await loadDetails(context);
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      final sessionId = await _sessionDataProvider.getSessionId();
      _movieDetails = await _movieApiClient.movieDetails(movieId, _locale);
      if (sessionId != null) {
        _isFavorite = await _movieApiClient.isFavorite(movieId, sessionId);
      }
      updateData(_movieDetails, _isFavorite);
    } on ApiClientException catch (e) {
      if (context.mounted) _handleApiClientException(e, context);
    }
  }

  void updateData(MovieDetails? details, bool isFavorite) {
    data.title = details?.title ?? 'Загрузка...';
    data.isLoading = details == null;
    if (details == null) {
      notifyListeners();
      return;
    }
    data.overview = details.overview ?? '';
    final iconData = isFavorite ? Icons.star : Icons.star_border;
    data.posterData = MovieDetailsPosterData(
      backdropPath: details.backdropPath,
      posterPath: details.posterPath,
      favoriteIcon: iconData,
    );
    var year = details.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    data.titleData = MovieDetailsTitleData(title: details.title, year: year);
    notifyListeners();
  }

  Future<void> toggleFavorite(BuildContext context) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    if (sessionId == null || accountId == null) return;

    _isFavorite = !_isFavorite;
    updateData(_movieDetails, _isFavorite);

    try {
      await _accountApiClient.markAsFavorite(
        accountId: accountId,
        sessionId: sessionId,
        mediaType: MediaType.movie,
        mediaId: movieId,
        isFavorite: _isFavorite,
      );
    } on ApiClientException catch (e) {
      if (context.mounted) _handleApiClientException(e, context);
    }
  }

  void _handleApiClientException(
      ApiClientException exception, BuildContext context) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        print(exception);
    }
  }
}
