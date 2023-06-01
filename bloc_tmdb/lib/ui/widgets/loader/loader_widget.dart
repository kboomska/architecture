import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_tmdb/ui/widgets/loader/loader_view_cubit.dart';
import 'package:bloc_tmdb/ui/navigation/main_navigation.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoaderViewCubit, LoaderViewCubitState>(
      listenWhen: (previous, current) =>
          current != LoaderViewCubitState.unknown,
      listener: onLoaderViewCubitStateChange,
      child: const Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  void onLoaderViewCubitStateChange(
      BuildContext context, LoaderViewCubitState state) {
    final nextScreen = state == LoaderViewCubitState.authorized
        ? MainNavigationRouteNames.mainScreen
        : MainNavigationRouteNames.auth;

    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(nextScreen);
    }
  }
}
