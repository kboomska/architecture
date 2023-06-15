import 'package:themoviedb/ui/widgets/movie_details/movie_details_widget_model.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/api_client/account_api_client.dart';
import 'package:themoviedb/ui/widgets/loader/loader_view_model.dart';
import 'package:themoviedb/domain/api_client/auth_api_client.dart';
import 'package:themoviedb/ui/widgets/auth/auth_view_model.dart';

class AuthService
    implements
        AuthViewModelLoginProvider,
        LoaderViewModelAuthStatusProvider,
        MovieDetailsWidgetModelLogoutProvider {
  final SessionDataProvider sessionDataProvider;
  final AccountApiClient accountApiClient;
  final AuthApiClient authApiClient;

  AuthService({
    required this.sessionDataProvider,
    required this.accountApiClient,
    required this.authApiClient,
  });

  @override
  Future<bool> isAuth() async {
    final sessionId = await sessionDataProvider.getSessionId();
    return sessionId != null;
  }

  @override
  Future<void> login(String login, String password) async {
    final sessionId = await authApiClient.auth(
      username: login,
      password: password,
    );
    final accountId = await accountApiClient.getAccountInfo(sessionId);

    await sessionDataProvider.setSessionId(sessionId);
    await sessionDataProvider.setAccountId(accountId);
  }

  @override
  Future<void> logout() async {
    await sessionDataProvider.removeSessionId();
    await sessionDataProvider.removeAccountId();
  }
}
