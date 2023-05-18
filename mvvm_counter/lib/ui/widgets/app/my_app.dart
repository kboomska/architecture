import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:mvvm_counter/ui/widgets/example/example_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVVM Counter',
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (_) => ViewModel(),
        child: const ExampleWidget(),
      ),
    );
  }
}
