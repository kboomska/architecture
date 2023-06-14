import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:dependency_injection/widgets/example/calculator_service.dart';
import 'package:dependency_injection/widgets/example/example_view_model.dart';
import 'package:dependency_injection/widgets/example/main_navigation.dart';
import 'package:dependency_injection/widgets/example/example_widget.dart';
import 'package:dependency_injection/widgets/example/summator.dart';
import 'package:dependency_injection/widgets/app/my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dependency_injection/main.dart';

void setupGetIt() {
  GetIt.instance.registerSingletonAsync<SharedPreferences>(
    SharedPreferences.getInstance,
  );
  // GetIt.instance.registerLazySingleton<ScreenFactory>(
  //   () => const ScreenFactoryDefault(),
  // );
  GetIt.instance.registerSingleton<ScreenFactory>(ScreenFactoryDefault());
  GetIt.instance.registerSingleton<MainNavigation>(MainNavigationDefault());
  GetIt.instance.registerFactory<Summator>(() => const Summator());
  GetIt.instance.registerFactory<CalculatorService>(() => CalculatorService());
  GetIt.instance.registerFactory<ExampleViewModel>(
    () => ExampleCalcViewModel(),
  );
  GetIt.instance.registerFactory<AppFactory>(() => const AppFactoryDefault());
}

class ScreenFactoryDefault implements ScreenFactory {
  ScreenFactoryDefault() {
    _setup();
  }

  Future<void> _setup() async {
    final storage = await GetIt.instance.getAsync<SharedPreferences>();
    storage.setBool('key', true);
  }

  @override
  Widget makeExampleScreen() => ExampleWidget();
}

class AppFactoryDefault implements AppFactory {
  const AppFactoryDefault();

  @override
  Widget makeApp() => MyApp();
}
