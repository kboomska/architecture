import 'dart:async';

import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import 'package:bloc_tmdb/ui/navigation/main_navigation.dart';
import 'package:bloc_tmdb/domain/services/auth_service.dart';
import 'package:bloc_tmdb/domain/blocs/auth_bloc.dart';

enum LoaderViewCubitState { authorized, notAuthorized, unknown }

class LoaderViewCubit extends Cubit<LoaderViewCubitState> {
  final AuthBloc authBloc;
  late final StreamSubscription<AuthState> authSubscription;
  LoaderViewCubit(
    LoaderViewCubitState initialState,
    this.authBloc,
  ) : super(initialState) {
    authBloc.add(AuthCheckStatusEvent());
    onState(authBloc.state);
    authSubscription = authBloc.stream.listen(onState);
  }

  void onState(AuthState state) {
    if (state is AuthAuthorizedState) {
      emit(LoaderViewCubitState.authorized);
    } else if (state is AuthNotAuthorizedState) {
      emit(LoaderViewCubitState.notAuthorized);
    }
  }

  @override
  Future<void> close() {
    authSubscription.cancel();
    return super.close();
  }
}
