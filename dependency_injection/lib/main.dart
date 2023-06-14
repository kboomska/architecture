import 'package:flutter/material.dart';

import 'package:dependency_injection/factories/service_locator.dart';

abstract class AppFactory {
  Widget makeApp();
}

void main() {
  final app = ServiceLocator.instance.makeApp();
  runApp(app);
}
