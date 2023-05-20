import 'package:flutter/material.dart';
import 'package:themoviedb/Library/Widgets/Inherited/provider.dart';
import 'package:themoviedb/ui/widgets/auth/auth_widget_model.dart';

import '../../theme/app_button_style.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to your account'),
        centerTitle: true,
      ),
      body: ListView(
        children: const [
          _HeaderWidget(),
        ],
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 16,
      color: Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          const _FormWidget(),
          const SizedBox(
            height: 25,
          ),
          const Text(
            'In order to use the editing and rating capabilities of TMDb, as well as get personal recommendations you will need to login to your account. If you do not have an account, registering for an account is free and simple.',
            style: textStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () {},
            style: AppButtonStyle.linkButton,
            child: const Text('Register'),
          ),
          const SizedBox(
            height: 25,
          ),
          const Text(
            'If you signed up but didn\'t get your verification email.',
            style: textStyle,
          ),
          const SizedBox(
            height: 5,
          ),
          TextButton(
            onPressed: () {},
            style: AppButtonStyle.linkButton,
            child: const Text('Verify email'),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<AuthWidgetModel>(context);

    const textStyle = TextStyle(
      fontSize: 16,
      color: Color(0xFF212529),
    );

    const inputDecoration = InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      isCollapsed: true,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorMessageWidget(),
        const Text(
          'Username',
          style: textStyle,
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: model?.loginTextController,
          decoration: inputDecoration,
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Password',
          style: textStyle,
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: model?.passwordTextController,
          decoration: inputDecoration,
          obscureText: true,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const _AuthButtonWidget(),
            const SizedBox(
              width: 20,
            ),
            TextButton(
              onPressed: () {},
              style: AppButtonStyle.linkButton,
              child: const Text('Reset password'),
            ),
          ],
        ),
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const textFieldColor = Color(0xFF01B4E4);
    final model = NotifierProvider.watch<AuthWidgetModel>(context);
    final onPressed =
        model?.canStartAuth == true ? () => model?.auth(context) : null;
    final child = model?.isAuthProgress == true
        ? const SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Text('Login');

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(textFieldColor),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent),
        textStyle: MaterialStateProperty.all(const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        )),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 15)),
      ),
      child: child,
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final errorMessage =
        NotifierProvider.watch<AuthWidgetModel>(context)?.errorMessage;
    if (errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Text(
        errorMessage,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.red,
        ),
      ),
    );
  }
}
