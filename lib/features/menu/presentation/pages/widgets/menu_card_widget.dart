import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nexus_estoque/core/constants/menus.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

class MenuCard extends StatelessWidget {
  final MenuItemInfo info;

  const MenuCard({
    super.key,
    required this.info,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          //Navigator.pushNamed(context, '/${info.route}');
          context.push('/${info.route}');
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryGrey,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FaIcon(info.icon),
                      ),
                    ),
                  ],
                ),
              ),
              Text(info.title),
            ],
          ),
        ),
      ),
    );
  }
}
