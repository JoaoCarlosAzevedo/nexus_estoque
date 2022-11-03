// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
    required this.userController,
    required this.passwordController,
    required this.onPressed,
  }) : super(key: key);

  final TextEditingController userController;
  final TextEditingController passwordController;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: <Widget>[
              const Text('Header'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        decoration:
                            const InputDecoration(label: Text("Usuário")),
                        controller: userController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        decoration: const InputDecoration(label: Text("Senha")),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        controller: passwordController,
                        onSubmitted: (e) {},
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: onPressed,
                        child: const SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Center(child: Text("Entrar")),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Text('Footer'),
            ],
          ),
        ),
      ],
    );
  }
}
