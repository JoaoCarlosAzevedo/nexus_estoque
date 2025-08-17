import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/core/constants/menus.dart';
import 'package:nexus_estoque/core/features/branches/data/model/branch_model.dart';
import 'package:nexus_estoque/core/features/branches/data/pages/branch_page.dart';
import 'package:nexus_estoque/core/services/secure_store.dart';
import 'package:nexus_estoque/features/auth/pages/login/cubit/auth_cubit.dart';
import 'package:nexus_estoque/features/auth/providers/login_controller_provider.dart';
import 'package:nexus_estoque/features/menu/presentation/pages/widgets/menu_card_widget.dart';

import '../../../auth/providers/login_state.dart';

class MenuPage extends ConsumerWidget {
  const MenuPage({
    super.key,
    this.crossAxisCount = 2,
    this.childAspectRatio = 2,
  });

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCubit = context.read<AuthCubit>();

    final authUser = ref.read(loginControllerProvider);

    List menus = menuItens;

    AsyncValue<Branch?> environment = ref.watch(environmentProvider);

    if (authUser is LoginStateSuccess) {
      final listMenus = authUser.user.menus;
      if (!authUser.user.title.contains("SEPARADOR TRANSFERENCIA")) {
        //copia;
        menus = [
          for (final newMenu in menuItens)
            if (newMenu.route != "separacao") newMenu,
        ];
      }

      if (listMenus.isNotEmpty) {
        menus = [
          for (final newMenu in menuItens)
            if (listMenus.contains(newMenu.route.trim())) newMenu,
        ];
      }
    }

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
          GestureDetector(
            onLongPress: () {
              LocalStorage.deleteBranch();
            },
            child: IconButton(
              onPressed: () {
                context.push('/filiais');
              },
              icon: const Icon(Icons.apartment_outlined),
            ),
          ),
          IconButton(
              onPressed: () {
                ref.read(loginControllerProvider.notifier).logout();
                authCubit.logout();
              },
              icon: const Icon(Icons.logout)),
          /*      IconButton(
              onPressed: () async {
                await LocalStorage.deleteAll();
              },
              icon: const Icon(Icons.delete_forever)), */
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (authUser is LoginStateSuccess)
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                  child: GestureDetector(
                    onTap: () {
                      //print(authUser.user.menus);
                    },
                    child: Text(
                        'Bem vindo, ${authUser.user.displayName} - ${authUser.user.title}'),
                  ),
                ),
              environment.when(
                loading: () => const CircularProgressIndicator(),
                error: (err, stack) => Text('Error: $err'),
                data: (environment) {
                  if (environment == null) {
                    return const Text("Nenhuma filial selecionada");
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: LogoWidget(
                            logo: environment.logo,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                              "${environment.groupCode} / ${environment.branchCode} - ${environment.branchName}",
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.start),
                        ),
                      ],
                    ),
                  );
                },
              ),
              /*   Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Olá, ${user.displayName}'),
              ),
              const SizedBox(
                height: 15,
              ), */
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: menus.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      //childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) =>
                        MenuCard(info: menus[index]),
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
