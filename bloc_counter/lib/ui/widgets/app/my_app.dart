import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_counter/ui/widgets/example/example_widget.dart';
import 'package:bloc_counter/domain/blocs/users_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVVM Counter',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => UsersBloc(),
        child: const ExampleWidget(),
      ),
    );
  }
}
