import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:themoviedb/ui/widgets/loader/loader_view_model.dart';
import 'package:themoviedb/ui/widgets/loader/loader_widget.dart';

class ScreenFactory {
  Widget makeLoader() {
    return Provider(
      lazy: false,
      create: (context) => LoaderViewModel(context),
      child: const LoaderWidget(),
    );
  }
}
