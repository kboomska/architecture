import 'package:flutter/material.dart';

import 'package:mvvm_counter/ui/widgets/example/example_widget.dart';
import 'package:mvvm_counter/ui/widgets/loader/loader_widget.dart';
import 'package:mvvm_counter/ui/widgets/auth/auth_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVVM Counter',
      debugShowCheckedModeBanner: false,
      home: LoaderWidget.create(),
      routes: {
        'auth': (_) => AuthWidget.create(),
        'example': (_) => ExampleWidget.create(),
      },
    );
  }
}
