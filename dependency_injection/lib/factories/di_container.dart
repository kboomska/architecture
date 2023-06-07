import 'package:flutter/material.dart';

import 'package:dependency_injection/widgets/example/calculator_service.dart';
import 'package:dependency_injection/widgets/example/example_view_model.dart';
import 'package:dependency_injection/widgets/example/main_navigation.dart';
import 'package:dependency_injection/widgets/example/example_widget.dart';
import 'package:dependency_injection/widgets/example/summator.dart';
import 'package:dependency_injection/widgets/app/my_app.dart';
import 'package:dependency_injection/main.dart';

MainDIContainer makeDIContainer() => _DIContainer();

class _DIContainer implements MainDIContainer, ScreenFactory {
  late final MainNavigation _mainNavigation;

  Summator _makeSummator() => const Summator();

  CalculatorService _makeCalculatorService() =>
      CalculatorService(_makeSummator());

  // ExampleViewModel _makeExampleViewModel() => const ExamplePetViewModel();

  ExampleViewModel _makeExampleViewModel() =>
      ExampleCalcViewModel(_makeCalculatorService());

  @override
  Widget makeExampleScreen() => ExampleWidget(model: _makeExampleViewModel());

  @override
  Widget makeApp() => MyApp(mainNavigation: _mainNavigation);

  _DIContainer() {
    _mainNavigation = MainNavigationDefault(this);
  }
}
