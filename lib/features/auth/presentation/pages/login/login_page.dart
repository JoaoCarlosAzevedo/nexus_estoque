import 'package:flutter/material.dart';
import 'package:nexus_estoque/features/auth/data/repositories/auth_repository.dart';
import 'package:nexus_estoque/features/auth/model/user_model.dart';

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
                          decoration: InputDecoration(label: Text("Usuário")),
                          controller: userController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: InputDecoration(label: Text("Senha")),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          controller: passwordController,
                          onSubmitted: (e) {
                            login();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: login,
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

  void login() async {
    late User user;
    final data =
        await repository.auth(userController.text, passwordController.text);
  }

/*   final loginProvider = FutureProvider<bool>((ref) async {
    final dio = Dio();
    late dynamic response;
    try {
      response = await dio.get(
          'http://187.94.63.58:38137/REST/api/oauth2/v1/token',
          queryParameters: {
            'username': "JOAO.NEXUS",
            'password': "Skate102030",
            'grant_type': "password"
          });

      if (response.statusCode == 201) {
        return true;
      }
    } on DioError catch (e) {
      print(e);
    }

    return false;
  }); */
}
