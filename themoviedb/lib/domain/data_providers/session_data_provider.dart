import 'package:themoviedb/Library/FlutterSecureStorage/secure_storage.dart';

abstract class Keys {
  static const sessionId = 'session_id';
  static const accountId = 'account_id';
}

abstract class SessionDataProvider {
  Future<String?> getSessionId();
  Future<void> setSessionId(String value);
  Future<void> removeSessionId();
  Future<int?> getAccountId();
  Future<void> setAccountId(int value);
  Future<void> removeAccountId();
}

class SessionDataProviderDefault implements SessionDataProvider {
  final SecureStorage secureStorage;

  const SessionDataProviderDefault(this.secureStorage);

  @override
  Future<String?> getSessionId() => secureStorage.read(key: Keys.sessionId);

  @override
  Future<void> setSessionId(String value) {
    return secureStorage.write(key: Keys.sessionId, value: value);
  }

  @override
  Future<void> removeSessionId() {
    return secureStorage.delete(key: Keys.sessionId);
  }

  @override
  Future<int?> getAccountId() async {
    final id = await secureStorage.read(key: Keys.accountId);
    return id != null ? int.tryParse(id) : null;
  }

  @override
  Future<void> setAccountId(int value) {
    return secureStorage.write(key: Keys.accountId, value: value.toString());
  }

  @override
  Future<void> removeAccountId() {
    return secureStorage.delete(key: Keys.accountId);
  }
}
