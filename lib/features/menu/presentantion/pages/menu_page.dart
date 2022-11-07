import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/core/constants/menus.dart';
import 'package:nexus_estoque/features/auth/presentation/pages/login/cubit/auth_cubit.dart';
import 'package:nexus_estoque/features/menu/presentantion/pages/widgets/menu_card_widget.dart';
import 'package:rive/rive.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({
    Key? key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 2,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final state = authCubit.state as AuthLoaded;
    final user = state.user;
    print(user);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/NexusIcon.png",
              fit: BoxFit.scaleDown,
              width: 50,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text("Nexus WMS")
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                authCubit.logout();
                /*      Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false); */
                context.go('/');
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Olá, ${user.displayName}'),
              ),
              const Expanded(
                flex: 1,
                child: Card(
                  elevation: 5,
                  child: Center(
                    child: RiveAnimation.asset(
                      fit: BoxFit.scaleDown,
                      'assets/inventory_app.riv',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: menuItens.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      //childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) =>
                        MenuCard(info: menuItens[index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
