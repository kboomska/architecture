import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:dependency_injection/widgets/example/example_view_model.dart';

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
              ElevatedButton(
                onPressed: () {
                  GetIt.instance.unregister<ExampleViewModel>();
                  GetIt.instance.registerFactory<ExampleViewModel>(
                    () => const ExamplePetViewModel(),
                  );
                },
                child: const Text('Press me 3'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
