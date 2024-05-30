import 'package:flutter/material.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double value;

  const ProgressIndicatorWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 5.0,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.progression(value)),
      ),
    );
  }
}
