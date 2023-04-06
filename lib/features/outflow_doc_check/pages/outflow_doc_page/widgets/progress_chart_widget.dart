import 'package:flutter/material.dart';
import 'package:nexus_estoque/core/theme/app_colors.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({Key? key, required this.value}) : super(key: key);
  final double value;
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: AppColors.primaryGrey,
      color: AppColors.progression(value),
      strokeWidth: 8,
      value: value,
    );
  }
}
