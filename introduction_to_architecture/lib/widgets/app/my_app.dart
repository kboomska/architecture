import 'package:flutter/material.dart';

import 'package:introduction_to_architecture/widgets/example/example_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Introduction to Architecture',
      debugShowCheckedModeBanner: false,
      home: ExampleWidget(),
    );
  }
}
