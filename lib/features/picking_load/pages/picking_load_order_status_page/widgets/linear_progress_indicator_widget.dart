import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final double value;

  const ProgressIndicatorWidget({Key? key, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 5.0,

        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        //backgroundColor: Theme.of(context).primaryColor,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    );
  }
}
