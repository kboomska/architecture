import 'package:themoviedb/domain/api_client/network_client.dart';
import 'package:themoviedb/configuration/configuration.dart';

enum MediaType { movie, tv }

extension MediaTypeAsString on MediaType {
  String asString() {
    switch (this) {
      case MediaType.movie:
        return 'movie';
      case MediaType.tv:
        return 'tv';
    }
  }
}

abstract class AccountApiClient {
  Future<int> getAccountInfo(
    String sessionId,
  );

  Future<void> markAsFavorite({
    required int accountId,
    required String sessionId,
    required MediaType mediaType,
    required int mediaId,
    required bool isFavorite,
  });
}

class AccountApiClientDefault implements AccountApiClient {
  final NetworkClient networkClient;

  const AccountApiClientDefault(this.networkClient);

  @override
  Future<int> getAccountInfo(
    String sessionId,
  ) async {
    int parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['id'] as int;
      return result;
    }

    final result = networkClient.get(
      '/account',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );

    return result;
  }

  @override
  Future<void> markAsFavorite({
    required int accountId,
    required String sessionId,
    required MediaType mediaType,
    required int mediaId,
    required bool isFavorite,
  }) async {
    final parameters = <String, dynamic>{
      'media_type': mediaType.asString(),
      'media_id': mediaId,
      'favorite': isFavorite,
    };

    String parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['status_message'] as String;
      return result;
    }

    networkClient.post(
      '/account/$accountId/favorite',
      parser,
      parameters,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
  }
}
