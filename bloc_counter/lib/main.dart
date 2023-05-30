import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_counter/domain/blocs/blocs_observer.dart';
import 'package:bloc_counter/ui/widgets/app/my_app.dart';

void main() {
  const app = MyApp();
  Bloc.observer = BlocsObserver();
  runApp(app);
}
