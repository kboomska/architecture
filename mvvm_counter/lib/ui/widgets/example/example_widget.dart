import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:mvvm_counter/domain/services/user_service.dart';

class ViewModelState {
  final String ageTitle;

  ViewModelState({
    required this.ageTitle,
  });
}

class ViewModel extends ChangeNotifier {
  final _userService = UserService();
  ViewModelState _state = ViewModelState(ageTitle: '');
  ViewModelState get state => _state;

  ViewModel() {
    loadValue();
  }

  Future<void> loadValue() async {
    await _userService.loadValue();
    _updateState();
  }

  Future<void> onIncrementButtonPressed() async {
    _userService.incrementAge();
    _updateState();
  }

  Future<void> onDecrementButtonPressed() async {
    _userService.decrementAge();
    _updateState();
  }

  void _updateState() {
    final user = _userService.user;

    _state = ViewModelState(
      ageTitle: user.age.toString(),
    );
    notifyListeners();
  }
}

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _AgeDecrementWidget(),
              _AgeTitle(),
              _AgeIncrementWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgeTitle extends StatelessWidget {
  const _AgeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final title =
        context.select((ViewModel viewModel) => viewModel.state.ageTitle);

    return SizedBox(
      width: 60,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _AgeIncrementWidget extends StatelessWidget {
  const _AgeIncrementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ViewModel>();

    return ElevatedButton(
      onPressed: viewModel.onIncrementButtonPressed,
      child: const Text('+'),
    );
  }
}

class _AgeDecrementWidget extends StatelessWidget {
  const _AgeDecrementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ViewModel>();

    return ElevatedButton(
      onPressed: viewModel.onDecrementButtonPressed,
      child: const Text('-'),
    );
  }
}
