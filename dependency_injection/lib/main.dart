import 'package:flutter/material.dart';

import 'package:dependency_injection/factories/di_container.dart';

abstract class MainDIContainer {
  Widget makeApp();
}

final diContainer = makeDIContainer();

void main() {
  final app = diContainer.makeApp();
  runApp(app);
}
