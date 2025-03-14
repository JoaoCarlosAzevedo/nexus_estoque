// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../../../core/features/barcode_scanner/barcode_scanner.dart';
import '../../../../../core/services/secure_store.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.userController,
    required this.passwordController,
    required this.onPressed,
  });

  final TextEditingController userController;
  final TextEditingController passwordController;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: <Widget>[
                //const Text('Header'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onLongPress: () async {
                        /*  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BluetoothPage(),
                          ),
                        ); */
                        await LocalStorage.deleteAll();

                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Registros Deletados"),
                        ));

                        // ignore: use_build_context_synchronously
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (ctx) {
                          return const BarcodeScanerPage();
                        }));
                      },
                      child: Image.asset(
                        "assets/NexusIcon.png",
                        fit: BoxFit.scaleDown,
                        width: 40,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text("Nexus WMS")
                  ],
                ),
                const Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 0,
                      child: Center(
                        child: RiveAnimation.asset(
                          fit: BoxFit.scaleDown,
                          'assets/inventory_app.riv',
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                        PasswordInput(passwordController: passwordController),
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
                const Text('Versão 1.1.30'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
    required this.passwordController,
  });

  final TextEditingController passwordController;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool showPassWord = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        label: const Text("Senha"),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              showPassWord = !showPassWord;
            });
          },
          //icon: const Icon(Icons.remove_red_eye),
          icon: showPassWord
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      obscureText: showPassWord,
      controller: widget.passwordController,
      onSubmitted: (e) {},
    );
  }
}
