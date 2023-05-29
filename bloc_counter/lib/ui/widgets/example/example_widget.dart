import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:bloc_counter/domain/blocs/users_cubit.dart';

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
    final cubit = context.read<UsersCubit>();
    return StreamBuilder<UsersState>(
      initialData: cubit.state,
      stream: cubit.stream,
      builder: (context, snapshot) {
        final age = snapshot.requireData.currentUser.age.toString();
        return Text(
          age,
          textAlign: TextAlign.center,
        );
      },
    );
  }
}

class _AgeIncrementWidget extends StatelessWidget {
  const _AgeIncrementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersCubit>();

    return ElevatedButton(
      onPressed: cubit.incrementAge,
      child: const Text('+'),
    );
  }
}

class _AgeDecrementWidget extends StatelessWidget {
  const _AgeDecrementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UsersCubit>();

    return ElevatedButton(
      onPressed: cubit.decrementAge,
      child: const Text('-'),
    );
  }
}
