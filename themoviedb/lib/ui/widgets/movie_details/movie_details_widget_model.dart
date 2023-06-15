import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:themoviedb/domain/local_entity/movie_details_local.dart';
import 'package:themoviedb/domain/api_client/api_client_exception.dart';
import 'package:themoviedb/ui/navigation/main_navigation_actions.dart';
import 'package:themoviedb/Library/localization_model_storage.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';

class MovieDetailsPosterData {
  final String? backdropPath;
  final String? posterPath;
  final bool isFavorite;
  IconData get favoriteIcon => isFavorite ? Icons.star : Icons.star_border;

  MovieDetailsPosterData({
    this.backdropPath,
    this.posterPath,
    this.isFavorite = false,
  });

  MovieDetailsPosterData copyWith({
    String? backdropPath,
    String? posterPath,
    bool? isFavorite,
  }) {
    return MovieDetailsPosterData(
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class MovieDetailsTitleData {
  final String title;
  final String year;

  MovieDetailsTitleData({
    required this.title,
    required this.year,
  });
}

class MovieDetailsScoreData {
  final String? trailerKey;
  final double voteAverage;

  MovieDetailsScoreData({
    this.trailerKey,
    required this.voteAverage,
  });
}

class MovieDetailsCrewData {
  final String name;
  final String job;

  MovieDetailsCrewData({
    required this.name,
    required this.job,
  });
}

class MovieDetailsActorData {
  final String name;
  final String character;
  final String? profilePath;

  MovieDetailsActorData({
    required this.name,
    required this.character,
    this.profilePath,
  });
}

class MovieDetailsData {
  String title = '';
  bool isLoading = true;
  String overview = '';
  MovieDetailsPosterData posterData = MovieDetailsPosterData();
  MovieDetailsTitleData titleData = MovieDetailsTitleData(title: '', year: '');
  MovieDetailsScoreData scoreData = MovieDetailsScoreData(voteAverage: 0);
  String summary = '';
  List<List<MovieDetailsCrewData>> crewData =
      const <List<MovieDetailsCrewData>>[];
  List<MovieDetailsActorData> actorsData = const <MovieDetailsActorData>[];
}

abstract class MovieDetailsWidgetModelLogoutProvider {
  Future<void> logout();
}

abstract class MovieDetailsWidgetModelMovieProvider {
  Future<MovieDetailsLocal> loadDetails({
    required int movieId,
    required String locale,
  });

  Future<void> updateFavorite({
    required int movieId,
    required bool isFavorite,
  });
}

class MovieDetailsWidgetModel extends ChangeNotifier {
  final MovieDetailsWidgetModelLogoutProvider logoutProvider;
  final MovieDetailsWidgetModelMovieProvider movieProvider;
  final MainNavigationActions navigationActions;

  final int movieId;
  final data = MovieDetailsData();
  final _localeStorage = LocalizationModelStorage();
  late DateFormat _dateFormat;

  MovieDetailsWidgetModel({
    required this.navigationActions,
    required this.logoutProvider,
    required this.movieProvider,
    required this.movieId,
  });

  Future<void> setupLocale(BuildContext context, Locale locale) async {
    if (!_localeStorage.isLocaleUpdated(locale)) return;

    _dateFormat = DateFormat.yMMMMd(_localeStorage.localeTag);
    updateData(null, false);
    await loadDetails(context);
  }

  void updateData(MovieDetails? details, bool isFavorite) {
    data.title = details?.title ?? 'Загрузка...';
    data.isLoading = details == null;
    if (details == null) {
      notifyListeners();
      return;
    }
    data.overview = details.overview ?? '';
    data.posterData = MovieDetailsPosterData(
      backdropPath: details.backdropPath,
      posterPath: details.posterPath,
      isFavorite: isFavorite,
    );
    var year = details.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    data.titleData = MovieDetailsTitleData(title: details.title, year: year);
    final videos = details.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube')
        .toList();
    final trailerKey = videos.isNotEmpty == true ? videos.first.key : null;
    data.scoreData = MovieDetailsScoreData(
      voteAverage: details.voteAverage * 10,
      trailerKey: trailerKey,
    );
    data.summary = makeSummary(details);
    data.crewData = makeCrewData(details);
    data.actorsData = details.credits.cast
        .map(
          (actor) => MovieDetailsActorData(
            name: actor.name,
            character: actor.character,
            profilePath: actor.profilePath,
          ),
        )
        .toList();
    notifyListeners();
  }

  List<List<MovieDetailsCrewData>> makeCrewData(MovieDetails details) {
    var crew = details.credits.crew
        .map(
          (employee) => MovieDetailsCrewData(
            name: employee.name,
            job: employee.job,
          ),
        )
        .toList();
    crew = crew.length > 4 ? crew.sublist(0, 4) : crew;
    var crewChunks = <List<MovieDetailsCrewData>>[];
    for (var i = 0; i < crew.length; i += 2) {
      crewChunks
          .add(crew.sublist(i, i + 2 > crew.length ? crew.length : i + 2));
    }
    return crewChunks;
  }

  String makeSummary(MovieDetails details) {
    var texts = <String>[];

    final releaseDate = details.releaseDate;
    if (releaseDate != null) {
      texts.add(_dateFormat.format(releaseDate));
    }

    if (details.productionCountries.isNotEmpty) {
      texts.add('(${details.productionCountries.first.iso})');
    }

    final runtime = details.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    texts.add('${hours}h ${minutes}m');

    if (details.genres.isNotEmpty) {
      var genreNames = <String>[];
      for (var genre in details.genres) {
        genreNames.add(genre.name);
      }
      texts.add(genreNames.join(', '));
    }
    // '🅁 05/17/2019 (US) • 2h 11m • Action, Thriller, Crime',
    return texts.join(' ');
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      final details = await movieProvider.loadDetails(
        movieId: movieId,
        locale: _localeStorage.localeTag,
      );

      updateData(details.details, details.isFavorite);
    } on ApiClientException catch (e) {
      if (context.mounted) _handleApiClientException(e, context);
    }
  }

  Future<void> toggleFavorite(BuildContext context) async {
    data.posterData =
        data.posterData.copyWith(isFavorite: !data.posterData.isFavorite);
    notifyListeners();
    try {
      await movieProvider.updateFavorite(
        movieId: movieId,
        isFavorite: data.posterData.isFavorite,
      );
    } on ApiClientException catch (e) {
      if (context.mounted) _handleApiClientException(e, context);
    }
  }

  void _handleApiClientException(
      ApiClientException exception, BuildContext context) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        logoutProvider.logout();
        navigationActions.resetNavigation(context);
        break;
      default:
        print(exception);
    }
  }
}
