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
      onGenerateRoute: (settings) {
        if (settings.name == 'auth') {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                AuthWidget.create(),
            transitionDuration: Duration.zero,
          );
        } else if (settings.name == 'example') {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ExampleWidget.create(),
            transitionDuration: Duration.zero,
          );
        } else {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                LoaderWidget.create(),
            transitionDuration: Duration.zero,
          );
        }
      },
    );
  }
}
