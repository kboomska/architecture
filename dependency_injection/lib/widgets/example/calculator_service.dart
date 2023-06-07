import 'package:dependency_injection/widgets/example/summator.dart';

enum CalculatorServiceOperation { sum }

class CalculatorService {
  final Summator summator;

  const CalculatorService(this.summator);

  int calculate(int a, int b, CalculatorServiceOperation operation) {
    if (operation == CalculatorServiceOperation.sum) {
      return summator.sum(a, b);
    } else {
      return 0;
    }
  }
}
