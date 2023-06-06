import 'package:flutter/material.dart';

import 'package:dependency_injection/widgets/example/example_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Dependency Injection',
      debugShowCheckedModeBanner: false,
      home: ExampleWidget(),
    );
  }
}
