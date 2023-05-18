import 'dart:math';

import 'package:flutter/material.dart';

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({super.key});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  var _value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _value = max(_value - 1, 0);
                  setState(() {});
                },
                child: const Text('-'),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  '$_value',
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _value += 1;
                  setState(() {});
                },
                child: const Text('+'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
