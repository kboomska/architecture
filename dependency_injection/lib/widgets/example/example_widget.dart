import 'package:flutter/material.dart';

import 'package:dependency_injection/widgets/example/example_view_model.dart';

enum ExampleWidgetMode { calc, pet }

class ExampleWidget extends StatelessWidget {
  final ExampleWidgetMode mode;
  final calcModel = const ExampleCalcViewModel();
  final petModel = const ExamplePetViewModel();

  const ExampleWidget({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: mode == ExampleWidgetMode.calc
                    ? calcModel.onPress
                    : petModel.onPress,
                child: const Text('Press'),
              ),
              ElevatedButton(
                onPressed: mode == ExampleWidgetMode.calc
                    ? calcModel.onPressMeToo
                    : petModel.onPressMeToo,
                child: const Text('Press me too'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
