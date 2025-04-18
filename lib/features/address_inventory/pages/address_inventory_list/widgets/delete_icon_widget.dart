import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/inventory_repository.dart';

class InventoryDeleteIcon extends ConsumerStatefulWidget {
  const InventoryDeleteIcon(
      {required this.recno, required this.onSuccess, super.key});
  final int recno;
  final VoidCallback onSuccess;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InventoryDeleteIconState();
}

class _InventoryDeleteIconState extends ConsumerState<InventoryDeleteIcon> {
  Future<bool>? future;

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(inventoryRepository);

    return SizedBox(
      width: 40,
      height: 40,
      child: FutureBuilder<bool>(
        future: future, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!) {
              widget.onSuccess();
              return const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              );
            } else {
              return const Icon(
                Icons.cancel_outlined,
                color: Colors.red,
              );
            }
          }
          if (snapshot.hasError) {
            return const Icon(
              Icons.cancel_outlined,
              color: Colors.red,
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return IconButton(
              onPressed: () {
                setState(() {
                  future = repository.deleteInventory(widget.recno);
                });
              },
              icon: const Icon(Icons.delete_forever));
        },
      ),
    );
  }
}
