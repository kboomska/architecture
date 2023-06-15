import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/api_client/account_api_client.dart';
import 'package:themoviedb/domain/api_client/auth_api_client.dart';
import 'package:themoviedb/ui/widgets/auth/auth_view_model.dart';

class AuthService implements AuthViewModelLoginProvider {
  final SessionDataProvider sessionDataProvider;
  final _accountApiClient = AccountApiClient();
  final _authApiClient = AuthApiClient();

  AuthService(this.sessionDataProvider);

  Future<bool> isAuth() async {
    final sessionId = await sessionDataProvider.getSessionId();
    return sessionId != null;
  }

  @override
  Future<void> login(String login, String password) async {
    final sessionId = await _authApiClient.auth(
      username: login,
      password: password,
    );
    final accountId = await _accountApiClient.getAccountInfo(sessionId);

    await sessionDataProvider.setSessionId(sessionId);
    await sessionDataProvider.setAccountId(accountId);
  }

  Future<void> logout() async {
    await sessionDataProvider.removeSessionId();
    await sessionDataProvider.removeAccountId();
  }
}
