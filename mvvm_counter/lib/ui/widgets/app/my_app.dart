import 'package:flutter/material.dart';

import 'package:mvvm_counter/ui/widgets/auth/auth_widget.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVVM Counter',
      debugShowCheckedModeBanner: false,
      home: AuthWidget.create(),
    );
  }
}
