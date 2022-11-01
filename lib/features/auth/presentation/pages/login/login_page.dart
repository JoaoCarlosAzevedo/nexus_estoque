import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/auth/data/repositories/auth_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthRepository repository = AuthRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CustomScrollView(
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
                          decoration:
                              const InputDecoration(label: Text("Senha")),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          controller: passwordController,
                          onSubmitted: (e) {},
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {},
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
      ),
    );
  }
}
