import 'package:flutter/material.dart';

Future<bool?> showBackDialog(BuildContext ctx) {
  return showDialog<bool>(
    context: ctx,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Atenção!'),
        content: const Text(
          'Deseja sair dessa página?',
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Não',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: Text(
              'Sim',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ],
      );
    },
  );
}
