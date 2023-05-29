import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_counter/domain/blocs/users_bloc.dart';

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersBloc, UsersState>(
      listenWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        print(state.currentUser.age);
      },
      child: Scaffold(
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
      ),
    );
  }
}

class _AgeTitle extends StatelessWidget {
  const _AgeTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final age = context
        .select((UsersBloc bloc) => bloc.state.currentUser.age)
        .toString();
    return Text(
      age,
      textAlign: TextAlign.center,
    );
  }
}

class _AgeIncrementWidget extends StatelessWidget {
  const _AgeIncrementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersBloc>();

    return ElevatedButton(
      onPressed: () => bloc.add(UsersIncrementEvent()),
      child: const Text('+'),
    );
  }
}

class _AgeDecrementWidget extends StatelessWidget {
  const _AgeDecrementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UsersBloc>();

    return ElevatedButton(
      onPressed: () => bloc.add(UsersDecrementEvent()),
      child: const Text('-'),
    );
  }
}

class ExampleForBlocConsumer extends StatelessWidget {
  const ExampleForBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsersBloc, UsersState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Text(state.currentUser.age.toString());
      },
    );
  }
}
