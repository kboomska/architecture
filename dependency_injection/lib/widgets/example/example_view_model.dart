import 'package:dependency_injection/widgets/example/calculator_service.dart';
import 'package:dependency_injection/widgets/example/example_widget.dart';

class ExampleCalcViewModel implements ExampleViewModel {
  final calculatorService = const CalculatorService();

  const ExampleCalcViewModel();

  @override
  void onPress() {
    final result =
        calculatorService.calculate(1, 2, CalculatorServiceOperation.sum);
    print(result);
  }

  @override
  void onPressMeToo() {
    print(5);
  }
}

class ExamplePetViewModel implements ExampleViewModel {
  const ExamplePetViewModel();

  @override
  void onPress() {
    print('woof woof');
  }

  @override
  void onPressMeToo() {
    print('meow meow');
  }
}
