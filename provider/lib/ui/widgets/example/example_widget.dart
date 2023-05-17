import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Model extends ChangeNotifier {
  var one = 0;
  var two = 0;

  void inc1() {
    one += 1;
    notifyListeners();
  }

  void inc2() {
    two += 1;
    notifyListeners();
  }
}

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({super.key});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  final model = Model();

  @override
  Widget build(BuildContext context) {
    // It helps when passing the model to another screen. In this case,
    // the receiving screen must have a ChangeNotifierProvider.value.
    // At this time the first screen continues to control the model.
    return ChangeNotifierProvider.value(
      value: model,
      child: const _View(),
    );
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }
}

class _View extends StatelessWidget {
  const _View({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<Model>();

    // context.read<Model>();
    // context.watch<Model>();
    // context.select((Model value) => value.one);

    // Provider.of(context, listen: true); // watch()
    // Provider.of(context, listen: false); // read()

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: model.inc1,
              child: const Text('one'),
            ),
            ElevatedButton(
              onPressed: model.inc2,
              child: const Text('two'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('complex'),
            ),
            const _OneWidget(),
            const _TwoWidget(),
            const _TreeWidget(),
            const _FourWidget(),
          ],
        ),
      ),
    );
  }
}

class _OneWidget extends StatelessWidget {
  const _OneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<Model>().one;

    return Text('$value');
  }
}

class _TwoWidget extends StatelessWidget {
  const _TwoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<Model>().two;

    return Text('$value');
  }
}

class _TreeWidget extends StatelessWidget {
  const _TreeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final value = 0;

    return Text('$value');
  }
}

class _FourWidget extends StatelessWidget {
  const _FourWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final value = 0;

    return Text('$value');
  }
}
