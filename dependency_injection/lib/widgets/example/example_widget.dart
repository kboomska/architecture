import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

abstract class ExampleViewModel {
  void onPress();
  void onPressMeToo();
}

class ExampleWidget extends StatelessWidget {
  final model = GetIt.instance<ExampleViewModel>();

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
