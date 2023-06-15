import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:themoviedb/ui/widgets/movie_details/movie_details_widget_model.dart';
import 'package:themoviedb/ui/widgets/movie_trailer/movie_trailer_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:themoviedb/Library/FlutterSecureStorage/secure_storage.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/widgets/tv_show_list/tv_show_list_widget.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_view_model.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:themoviedb/ui/navigation/main_navigation_actions.dart';
import 'package:themoviedb/domain/api_client/account_api_client.dart';
import 'package:themoviedb/ui/widgets/loader/loader_view_model.dart';
import 'package:themoviedb/domain/api_client/movie_api_client.dart';
import 'package:themoviedb/Library/HttpClient/app_http_client.dart';
import 'package:themoviedb/domain/api_client/auth_api_client.dart';
import 'package:themoviedb/domain/api_client/network_client.dart';
import 'package:themoviedb/ui/widgets/auth/auth_view_model.dart';
import 'package:themoviedb/ui/widgets/loader/loader_widget.dart';
import 'package:themoviedb/domain/services/movie_service.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/domain/services/auth_service.dart';
import 'package:themoviedb/ui/widgets/auth/auth_widget.dart';
import 'package:themoviedb/ui/widgets/news/news_widget.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';
import 'package:themoviedb/main.dart';

AppFactory makeAppFactory() => const _AppFactoryDefault();

class _AppFactoryDefault implements AppFactory {
  final _diContainer = const _DIContainer();

  const _AppFactoryDefault();

  @override
  Widget makeApp() => MyApp(
        navigation: _diContainer._makeMyAppNavigation(),
      );
}

class _DIContainer {
  final _mainNavigationActions = const MainNavigationActions();
  final SecureStorage _secureStorage = const SecureStorageDefault();
  final AppHttpClient _httpClient = const AppHttpClientDefault();

  const _DIContainer();

  ScreenFactory _makeScreenFactory() => ScreenFactoryDefault(this);

  MyAppNavigation _makeMyAppNavigation() =>
      MainNavigation(_makeScreenFactory());

  SessionDataProvider _makeSessionDataProvider() =>
      SessionDataProviderDefault(_secureStorage);

  NetworkClient _makeNetworkClient() => NetworkClientDefault(_httpClient);

  AccountApiClient _makeAccountApiClient() =>
      AccountApiClientDefault(_makeNetworkClient());

  AuthApiClient _makeAuthApiClient() =>
      AuthApiClientDefault(_makeNetworkClient());

  AuthService _makeAuthService() => AuthService(
        sessionDataProvider: _makeSessionDataProvider(),
        accountApiClient: _makeAccountApiClient(),
        authApiClient: _makeAuthApiClient(),
      );

  MovieApiClient _makeMovieApiClient() =>
      MovieApiClientDefault(_makeNetworkClient());

  MovieService _makeMovieService() => MovieService(
        sessionDataProvider: _makeSessionDataProvider(),
        accountApiClient: _makeAccountApiClient(),
        movieApiClient: _makeMovieApiClient(),
      );

  AuthViewModel _makeAuthViewModel() => AuthViewModel(
        mainNavigationActions: _mainNavigationActions,
        loginProvider: _makeAuthService(),
      );

  LoaderViewModel _makeLoaderViewModel(BuildContext context) => LoaderViewModel(
        context: context,
        authStatusProvider: _makeAuthService(),
      );
}

class ScreenFactoryDefault implements ScreenFactory {
  final _DIContainer _diContainer;

  const ScreenFactoryDefault(this._diContainer);

  @override
  Widget makeLoader() {
    return Provider(
      lazy: false,
      create: (context) => _diContainer._makeLoaderViewModel(context),
      child: const LoaderWidget(),
    );
  }

  @override
  Widget makeAuth() {
    return ChangeNotifierProvider(
      create: (_) => _diContainer._makeAuthViewModel(),
      child: const AuthWidget(),
    );
  }

  @override
  Widget makeMainScreen() {
    return const MainScreenWidget();
  }

  @override
  Widget makeMovieDetails(int movieId) {
    return ChangeNotifierProvider(
      create: (_) => MovieDetailsWidgetModel(movieId),
      child: const MovieDetailsWidget(),
    );
  }

  @override
  Widget makeMovieTrailer(String youtubeKey) {
    return MovieTrailerWidget(youtubeKey: youtubeKey);
  }

  @override
  Widget makeNewsList() {
    return const NewsWidget();
  }

  @override
  Widget makeMovieList() {
    return ChangeNotifierProvider(
      create: (_) => MovieListViewModel(),
      child: const MovieListWidget(),
    );
  }

  @override
  Widget makeTVShowList() {
    return const TVShowListWidget();
  }
}
