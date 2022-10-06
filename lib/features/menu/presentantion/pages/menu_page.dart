import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexus_estoque/core/constants/menus.dart';
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/configuracoes');
              },
              child: FaIcon(
                FontAwesomeIcons.gear,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 5,
                  color: Theme.of(context).backgroundColor,
                  child: const Center(
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
