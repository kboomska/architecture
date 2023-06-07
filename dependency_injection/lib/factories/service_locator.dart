import 'package:flutter/material.dart';

import 'package:dependency_injection/widgets/example/calculator_service.dart';
import 'package:dependency_injection/widgets/example/example_view_model.dart';
import 'package:dependency_injection/widgets/example/main_navigation.dart';
import 'package:dependency_injection/widgets/example/example_widget.dart';
import 'package:dependency_injection/widgets/example/summator.dart';
import 'package:dependency_injection/widgets/app/my_app.dart';

class ServiceLocator {
  static final instance = ServiceLocator._();
  ServiceLocator._();

  final MainNavigation mainNavigation = MainNavigationDefault();

  Summator makeSummator() => const Summator();

  CalculatorService makeCalculatorService() => CalculatorService();

  ExampleViewModel makeExampleViewModel() => ExampleCalcViewModel();

  Widget makeExampleScreen() => ExampleWidget();

  Widget makeApp() => MyApp();
}
