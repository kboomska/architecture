import 'package:mvvm_counter/domain/data_providers/session_data_provider.dart';
import 'package:mvvm_counter/domain/data_providers/auth_api_provider.dart';

class AuthService {
  final _sessionDataProvider = SessionDataProvider();
  final _authApiProvider = AuthApiProvider();

  Future<bool> checkAuth() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final apiKey = await _sessionDataProvider.getApiKey();
    return apiKey != null;
  }

  Future<void> login(String login, String password) async {
    final apiKey = await _authApiProvider.login(login, password);
    await _sessionDataProvider.setApiKey(apiKey);
  }

  Future<void> logout() async {
    await _sessionDataProvider.removeApiKey();
  }
}
