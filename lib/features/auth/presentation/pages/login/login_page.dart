import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/features/auth/data/repositories/auth_repository.dart';
import 'package:nexus_estoque/features/auth/presentation/pages/login/cubit/auth_cubit.dart';
import 'package:nexus_estoque/features/auth/presentation/pages/login/widgets/login_form.dart';
import 'package:nexus_estoque/features/auth/services/auth_service.dart';

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
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.rightSlide,
                    //title: 'Alerta',
                    desc: state.error.error,
                    //btnCancelOnPress: () {},
                    btnOkOnPress: () {},
                    btnOkColor: Theme.of(context).primaryColor)
                .show();
          }

          if (state is AuthLoaded) {
            context.read<AuthService>().login();
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final cubit = BlocProvider.of<AuthCubit>(context);
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return LoginForm(
              userController: userController,
              passwordController: passwordController,
              onPressed: () {
                cubit.login(userController.text, passwordController.text);
              },
            );
          },
        ),
      ),
    );
  }
}
