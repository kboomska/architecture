import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:mvvm_counter/ui/navigation/main_navigation.dart';
import 'package:mvvm_counter/domain/services/auth_service.dart';
import 'package:mvvm_counter/domain/services/user_service.dart';

class _ViewModelState {
  final String ageTitle;

  _ViewModelState({
    required this.ageTitle,
  });
}

class _ViewModel extends ChangeNotifier {
  final _userService = UserService();
  final _authService = AuthService();

  _ViewModelState _state = _ViewModelState(ageTitle: '');
  _ViewModelState get state => _state;

  _ViewModel() {
    loadValue();
  }

  Future<void> loadValue() async {
    await _userService.initialize();
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

  Future<void> onLogoutButtonPressed(BuildContext context) async {
    await _authService.logout();
    if (context.mounted) MainNavigation.showLoader(context);
  }

  void _updateState() {
    final user = _userService.user;

    _state = _ViewModelState(
      ageTitle: user.age.toString(),
    );
    notifyListeners();
  }
}

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const ExampleWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Укажите возраст'),
        centerTitle: true,
        actions: [
          IconButton(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onPressed: () => viewModel.onLogoutButtonPressed(context),
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
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
        context.select((_ViewModel viewModel) => viewModel.state.ageTitle);

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
    final viewModel = context.read<_ViewModel>();

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
    final viewModel = context.read<_ViewModel>();

    return ElevatedButton(
      onPressed: viewModel.onDecrementButtonPressed,
      child: const Text('-'),
    );
  }
}
