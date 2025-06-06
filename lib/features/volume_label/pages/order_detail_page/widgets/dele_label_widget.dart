import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repositories/volume_label_repository.dart';

class LabelDeleteIcon extends ConsumerStatefulWidget {
  const LabelDeleteIcon(
      {required this.param, required this.onSuccess, super.key});
  final String param;
  final VoidCallback onSuccess;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LabelDeleteIconState();
}

class _LabelDeleteIconState extends ConsumerState<LabelDeleteIcon> {
  Future<String>? future;

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(volumeLabelRepository);

    return SizedBox(
      width: 40,
      height: 40,
      child: FutureBuilder<String>(
        future: future, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
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
                  future = repository.deleteVolumeLabel(widget.param);
                });
              },
              icon: const Icon(Icons.delete_forever));
        },
      ),
    );
  }
}
