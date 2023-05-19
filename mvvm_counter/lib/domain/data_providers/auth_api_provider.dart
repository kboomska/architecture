abstract class AuthApiProviderError {}

class AuthApiProviderIncorrectLoginDataError extends Error {}

class AuthApiProvider {
  Future<String> login(String login, String password) async {
    final isSuccess = login == 'admin' && password == '123456';
    if (isSuccess) {
      return 'ntvu84ytvoisd08qe9mk53fqwviajsutp293lkf';
    } else {
      throw AuthApiProviderIncorrectLoginDataError();
    }
  }
}
