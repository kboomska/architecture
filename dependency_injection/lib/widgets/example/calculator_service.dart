import 'package:dependency_injection/factories/service_locator.dart';

enum CalculatorServiceOperation { sum }

class CalculatorService {
  final summator = ServiceLocator.instance.makeSummator();

  int calculate(int a, int b, CalculatorServiceOperation operation) {
    if (operation == CalculatorServiceOperation.sum) {
      return summator.sum(a, b);
    } else {
      return 0;
    }
  }
}
