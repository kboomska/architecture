import 'dart:math';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class ViewModel extends ChangeNotifier {
  var _age = 0;
  int get age => _age;

  ViewModel() {
    loadValue();
  }

  void loadValue() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    _age = sharedPreferences.getInt('age') ?? 0;
    notifyListeners();
  }

  Future<void> incrementAge() async {
    _age += 1;
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('age', _age);
    notifyListeners();
  }

  Future<void> decrementAge() async {
    _age = max(_age - 1, 0);
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt('age', _age);
    notifyListeners();
  }
}

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: viewModel.decrementAge,
                child: const Text('-'),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  '${viewModel.age}',
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: viewModel.incrementAge,
                child: const Text('+'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
