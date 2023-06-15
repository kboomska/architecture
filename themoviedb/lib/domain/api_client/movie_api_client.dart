import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import 'package:themoviedb/domain/api_client/network_client.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';
import 'package:themoviedb/configuration/configuration.dart';

abstract class MovieApiClient {
  Future<PopularMovieResponse> popularMovies(
    int page,
    String language,
    String apiKey,
  );

  Future<PopularMovieResponse> searchMovies(
    int page,
    String language,
    String query,
    String apiKey,
  );

  Future<MovieDetails> movieDetails(
    int movieId,
    String locale,
  );

  Future<bool> isFavorite(
    int movieId,
    String sessionId,
  );
}

class MovieApiClientDefault implements MovieApiClient {
  final NetworkClient networkClient;

  const MovieApiClientDefault(this.networkClient);

  @override
  Future<PopularMovieResponse> popularMovies(
    int page,
    String language,
    String apiKey,
  ) async {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = networkClient.get(
      '/movie/popular',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        'page': page.toString(),
        'language': language,
      },
    );

    return result;
  }

  @override
  Future<PopularMovieResponse> searchMovies(
    int page,
    String language,
    String query,
    String apiKey,
  ) async {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = networkClient.get(
      '/search/movie',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        'page': page.toString(),
        'language': language,
        'include_adult': true.toString(),
        'query': query,
      },
    );

    return result;
  }

  @override
  Future<MovieDetails> movieDetails(
    int movieId,
    String locale,
  ) async {
    MovieDetails parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    }

    final result = networkClient.get(
      '/movie/$movieId',
      parser,
      <String, dynamic>{
        'append_to_response': 'credits,videos',
        'api_key': Configuration.apiKey,
        'language': locale,
      },
    );

    return result;
  }

  @override
  Future<bool> isFavorite(
    int movieId,
    String sessionId,
  ) async {
    bool parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['favorite'] as bool;
      return result;
    }

    final result = networkClient.get(
      '/movie/$movieId/account_states',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );

    return result;
  }
}
