import 'package:flutter/material.dart';

import 'package:provider/ui/widgets/example/example_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExampleWidget(),
    );
  }
}
