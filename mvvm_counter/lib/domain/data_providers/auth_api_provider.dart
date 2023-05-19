abstract class AuthApiProviderError {}

class AuthApiProviderIncorrectLoginDataError {}

class AuthApiProvider {
  Future<String> login(String login, String password) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final isSuccess = login == 'admin' && password == '123456';
    if (isSuccess) {
      return 'ntvu84ytvoisd08qe9mk53fqwviajsutp293lkf';
    } else {
      throw AuthApiProviderIncorrectLoginDataError();
    }
  }
}
