import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart';

/*
1) Каждый экран представлен Stateful-виджетом - Screen.
2) Логаика хранится в стейте (State) - Controller.
3) Верстка хранится в StatelessWidget - Layout.
4) Controller передается в Layout с помощью InheritedWidget.
5) Саму верстку страницы необходимо разбить на виджеты.
*/

/* Популярные составляющие приложения элементы:

-- Наш модуль
1 - Экран

-- View слой
2 - Верстка
3 - Навигация
4 - Маппинг доменных данных в данные верстки
5 - Стейт

-- Доменный слой
6 - Бизнес логика (какие-то расчеты/изменения данных)

-- Слой доступа к данным
7 - Сетевые запросы
8 - БД (постоянное хранилище данных)
9 - Камера
10 - Геолокация
*/

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => Controller();
}

class Controller extends State<ExampleScreen> {
  final _repository = Repository();
  var _posts = <dynamic>[];
  Future<void> _loadPosts() async {
    final json = await _repository.loadPosts();
    _posts += json;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      state: this,
      child: const _Layout(),
    );
  }
}

class Repository {
  Future<List<dynamic>> loadPosts() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await get(url);
    final json = jsonDecode(response.body) as List<dynamic>;
    return json;
  }
}

class _Layout extends StatelessWidget {
  const _Layout({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.dependOnInheritedWidgetOfExactType<Provider>()!.state;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: state._loadPosts,
              child: const Text('Download'),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: state._posts.length,
                  itemBuilder: (context, index) {
                    return _RowWidget(
                      title: state._posts[index]['title'] as String,
                      body: state._posts[index]['body'] as String,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class _RowWidget extends StatelessWidget {
  final String title;
  final String body;

  const _RowWidget({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(title),
          Text(body),
          const Divider(height: 30),
        ],
      ),
    );
  }
}

class Provider extends InheritedWidget {
  final Controller state;

  const Provider({
    super.key,
    required this.state,
    required Widget child,
  }) : super(child: child);

  static Provider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>();
  }

  static Provider? read(BuildContext context) {
    final widget =
        context.getElementForInheritedWidgetOfExactType<Provider>()?.widget;
    return widget is Provider ? widget : null;
  }

  @override
  bool updateShouldNotify(Provider oldWidget) {
    return true;
  }
}
