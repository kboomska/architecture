import 'package:flutter/material.dart';

import 'package:dependency_injection/factories/service_locator.dart';

abstract class ExampleViewModel {
  void onPress();
  void onPressMeToo();
}

class ExampleWidget extends StatelessWidget {
  final model = ServiceLocator.instance.makeExampleViewModel();

  ExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: model.onPress,
                child: const Text('Press'),
              ),
              ElevatedButton(
                onPressed: model.onPressMeToo,
                child: const Text('Press me too'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
