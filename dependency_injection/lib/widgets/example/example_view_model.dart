import 'package:dependency_injection/widgets/example/calculator_service.dart';

class ExampleCalcViewModel {
  final calculatorService = const CalculatorService();

  const ExampleCalcViewModel();

  void onPress() {
    final result =
        calculatorService.calculate(1, 2, CalculatorServiceOperation.sum);
    print(result);
  }

  void onPressMeToo() {
    print(5);
  }
}

class ExamplePetViewModel {
  const ExamplePetViewModel();

  void onPress() {
    print('woof woof');
  }

  void onPressMeToo() {
    print('meow meow');
  }
}
