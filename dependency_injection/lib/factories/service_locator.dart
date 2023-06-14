import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:dependency_injection/widgets/example/calculator_service.dart';
import 'package:dependency_injection/widgets/example/example_view_model.dart';
import 'package:dependency_injection/widgets/example/main_navigation.dart';
import 'package:dependency_injection/widgets/example/example_widget.dart';
import 'package:dependency_injection/widgets/example/summator.dart';
import 'package:dependency_injection/widgets/app/my_app.dart';
import 'package:dependency_injection/main.dart';

void setupGetIt() {
  GetIt.instance.registerSingleton<ScreenFactory>(const ScreenFactoryDefault());
  GetIt.instance.registerSingleton<MainNavigation>(MainNavigationDefault());
  GetIt.instance.registerFactory<Summator>(() => const Summator());
  GetIt.instance.registerFactory<CalculatorService>(() => CalculatorService());
  GetIt.instance.registerFactory<ExampleViewModel>(
    () => ExampleCalcViewModel(),
  );
  GetIt.instance.registerFactory<AppFactory>(() => const AppFactoryDefault());
}

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

class ScreenFactoryDefault implements ScreenFactory {
  const ScreenFactoryDefault();

  @override
  Widget makeExampleScreen() => ExampleWidget();
}

class AppFactoryDefault implements AppFactory {
  const AppFactoryDefault();

  @override
  Widget makeApp() => MyApp();
}
