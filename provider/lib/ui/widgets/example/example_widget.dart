import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Complex {
  final int valueOne;
  final int valueTwo;

  Complex({
    required this.valueOne,
    required this.valueTwo,
  });

  Complex copyWith({
    int? valueOne,
    int? valueTwo,
  }) {
    return Complex(
      valueOne: valueOne ?? this.valueOne,
      valueTwo: valueTwo ?? this.valueTwo,
    );
  }

  @override
  String toString() => 'Complex(valueOne: $valueOne, valueTwo: $valueTwo)';

  @override
  bool operator ==(covariant Complex other) {
    if (identical(this, other)) return true;

    return other.valueOne == valueOne && other.valueTwo == valueTwo;
  }

  @override
  int get hashCode => valueOne.hashCode ^ valueTwo.hashCode;
}

class Model {
  final int one;
  final int two;
  final Complex complex;
  Model({
    required this.one,
    required this.two,
    required this.complex,
  });

  Model copyWith({
    int? one,
    int? two,
    Complex? complex,
  }) {
    return Model(
      one: one ?? this.one,
      two: two ?? this.two,
      complex: complex ?? this.complex,
    );
  }

  @override
  String toString() => 'Model(one: $one, two: $two, complex: $complex)';

  @override
  bool operator ==(covariant Model other) {
    if (identical(this, other)) return true;

    return other.one == one && other.two == two && other.complex == complex;
  }

  @override
  int get hashCode => one.hashCode ^ two.hashCode ^ complex.hashCode;
}

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({super.key});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  var model = Model(
    one: 0,
    two: 0,
    complex: Complex(
      valueOne: 0,
      valueTwo: 0,
    ),
  );

  void inc1() {
    model = model.copyWith(one: model.one + 1);
    setState(() {});
  }

  void inc2() {
    model = model.copyWith(two: model.two + 1);

    setState(() {});
  }

  void incComplex1() {
    final complex = model.complex.copyWith(
      valueOne: model.complex.valueOne + 1,
    );
    model = model.copyWith(complex: complex);

    setState(() {});
  }

  void incComplex2() {
    final complex = model.complex.copyWith(
      valueTwo: model.complex.valueTwo + 1,
    );
    model = model.copyWith(complex: complex);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: this),
        Provider.value(value: model),
      ],
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<_ExampleWidgetState>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: state.inc1,
              child: const Text('one'),
            ),
            ElevatedButton(
              onPressed: state.inc2,
              child: const Text('two'),
            ),
            ElevatedButton(
              onPressed: state.incComplex1,
              child: const Text('complex1'),
            ),
            ElevatedButton(
              onPressed: state.incComplex2,
              child: const Text('complex2'),
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
    final value = context.select((Model value) => value.one);

    return Text('$value');
  }
}

class _TwoWidget extends StatelessWidget {
  const _TwoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.select((Model value) => value.two);

    return Text('$value');
  }
}

class _TreeWidget extends StatelessWidget {
  const _TreeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.select((Model value) => value.complex.valueOne);

    return Text('$value');
  }
}

class _FourWidget extends StatelessWidget {
  const _FourWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.select((Model value) => value.complex.valueTwo);

    return Text('$value');
  }
}
