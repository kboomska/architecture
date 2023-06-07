import 'package:flutter/material.dart';

import 'package:dependency_injection/factories/service_locator.dart';

void main() {
  final app = ServiceLocator.instance.makeApp();
  runApp(app);
}
