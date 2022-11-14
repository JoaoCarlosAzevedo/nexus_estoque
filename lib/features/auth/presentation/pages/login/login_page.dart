import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexus_estoque/features/auth/presentation/pages/login/cubit/auth_cubit.dart';
import 'package:nexus_estoque/features/auth/presentation/pages/login/widgets/login_form.dart';
import 'package:nexus_estoque/features/auth/providers/login_controller_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  //final AuthRepository repository = AuthRepository(ref);

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
            ref.read(loginControllerProvider.notifier).login();
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final cubit = BlocProvider.of<AuthCubit>(context);
            print(state);
            if (state is AuthLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is AuthInitial) {
              return LoginForm(
                userController: userController,
                passwordController: passwordController,
                onPressed: () {
                  cubit.login(userController.text, passwordController.text);
                },
              );
            }

            /*  if (state is AuthLoaded) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
 */
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