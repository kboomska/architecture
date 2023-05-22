import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import 'package:themoviedb/domain/api_client/movie_api_client.dart';
import 'package:themoviedb/configuration/configuration.dart';

class MovieService {
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
}
