import 'package:flutter/material.dart';

import 'package:themoviedb/Library/Widgets/Inherited/provider.dart';
import 'package:themoviedb/ui/widgets/app/my_app_model.dart';
import 'package:themoviedb/ui/widgets/app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final model = MyAppModel();
  await model.chechAuth();

  const app = MyApp();
  final widget = Provider(
    model: model,
    child: app,
  );

  runApp(widget);
}
