import 'package:themoviedb/ui/widgets/movie_details/movie_details_widget_model.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_view_model.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/local_entity/movie_details_local.dart';
import 'package:themoviedb/domain/api_client/account_api_client.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import 'package:themoviedb/domain/api_client/movie_api_client.dart';
import 'package:themoviedb/configuration/configuration.dart';

class MovieService
    implements
        MovieDetailsWidgetModelMovieProvider,
        MovieListViewModelMoviesProvider {
  final SessionDataProvider sessionDataProvider;
  final AccountApiClient accountApiClient;
  final MovieApiClient movieApiClient;

  const MovieService({
    required this.sessionDataProvider,
    required this.accountApiClient,
    required this.movieApiClient,
  });

  @override
  Future<PopularMovieResponse> popularMovies(
    int page,
    String locale,
  ) async {
    return movieApiClient.popularMovies(
      page,
      locale,
      Configuration.apiKey,
    );
  }

  @override
  Future<PopularMovieResponse> searchMovies(
    int page,
    String locale,
    String query,
  ) async {
    return movieApiClient.searchMovies(
      page,
      locale,
      query,
      Configuration.apiKey,
    );
  }

  @override
  Future<MovieDetailsLocal> loadDetails({
    required int movieId,
    required String locale,
  }) async {
    var isFavorite = false;
    final sessionId = await sessionDataProvider.getSessionId();
    final movieDetails = await movieApiClient.movieDetails(movieId, locale);
    if (sessionId != null) {
      isFavorite = await movieApiClient.isFavorite(movieId, sessionId);
    }

    return MovieDetailsLocal(details: movieDetails, isFavorite: isFavorite);
  }

  @override
  Future<void> updateFavorite({
    required int movieId,
    required bool isFavorite,
  }) async {
    final sessionId = await sessionDataProvider.getSessionId();
    final accountId = await sessionDataProvider.getAccountId();

    if (sessionId == null || accountId == null) return;

    await accountApiClient.markAsFavorite(
      accountId: accountId,
      sessionId: sessionId,
      mediaType: MediaType.movie,
      mediaId: movieId,
      isFavorite: isFavorite,
    );
  }
}
