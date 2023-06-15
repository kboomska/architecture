import 'dart:io';

abstract class AppHttpClient {
  Future<HttpClientRequest> getUrl(Uri url);
  Future<HttpClientRequest> postUrl(Uri url);
}

class AppHttpClientDefault implements AppHttpClient {
  static final _client = HttpClient();

  const AppHttpClientDefault();

  @override
  Future<HttpClientRequest> getUrl(Uri url) => _client.getUrl(url);

  @override
  Future<HttpClientRequest> postUrl(Uri url) => _client.postUrl(url);
}
