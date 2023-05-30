import 'package:bloc_tmdb/domain/data_providers/session_data_provider.dart';
import 'package:bloc_tmdb/domain/local_entity/movie_details_local.dart';
import 'package:bloc_tmdb/domain/api_client/account_api_client.dart';
import 'package:bloc_tmdb/domain/entity/popular_movie_response.dart';
import 'package:bloc_tmdb/domain/api_client/movie_api_client.dart';
import 'package:bloc_tmdb/configuration/configuration.dart';

class MovieService {
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();
  final _movieApiClient = MovieApiClient();

  Future<PopularMovieResponse> popularMovies(
    int page,
    String locale,
  ) async {
    return _movieApiClient.popularMovies(
      page,
      locale,
      Configuration.apiKey,
    );
  }

  Future<PopularMovieResponse> searchMovies(
    int page,
    String locale,
    String query,
  ) async {
    return _movieApiClient.searchMovies(
      page,
      locale,
      query,
      Configuration.apiKey,
    );
  }

  Future<MovieDetailsLocal> loadDetails({
    required int movieId,
    required String locale,
  }) async {
    var isFavorite = false;
    final sessionId = await _sessionDataProvider.getSessionId();
    final movieDetails = await _movieApiClient.movieDetails(movieId, locale);
    if (sessionId != null) {
      isFavorite = await _movieApiClient.isFavorite(movieId, sessionId);
    }

    return MovieDetailsLocal(details: movieDetails, isFavorite: isFavorite);
  }

  Future<void> updateFavorite({
    required int movieId,
    required bool isFavorite,
  }) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();

    if (sessionId == null || accountId == null) return;

    await _accountApiClient.markAsFavorite(
      accountId: accountId,
      sessionId: sessionId,
      mediaType: MediaType.movie,
      mediaId: movieId,
      isFavorite: isFavorite,
    );
  }
}
