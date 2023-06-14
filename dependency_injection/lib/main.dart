import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:dependency_injection/factories/service_locator.dart';

abstract class AppFactory {
  Widget makeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupGetIt();
  await GetIt.instance.allReady();
  final appFactory = GetIt.instance<AppFactory>();
  final app = appFactory.makeApp();
  runApp(app);
}
