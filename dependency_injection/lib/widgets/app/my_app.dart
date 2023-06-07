import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  final Widget widget;
  const MyApp({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dependency Injection',
      debugShowCheckedModeBanner: false,
      home: widget,
    );
  }
}
