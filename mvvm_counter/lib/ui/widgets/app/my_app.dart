import 'package:flutter/material.dart';

import 'package:mvvm_counter/ui/widgets/example/example_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MVVM Counter',
      debugShowCheckedModeBanner: false,
      home: ExampleWidget(),
    );
  }
}
