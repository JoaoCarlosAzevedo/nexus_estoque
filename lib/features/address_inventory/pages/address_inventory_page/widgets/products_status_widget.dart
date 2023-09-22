import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/features/searches/products/provider/remote_product_provider.dart';

class ProductsStatusWidget extends ConsumerWidget {
  const ProductsStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final producsProvider = ref.watch(remoteProductProvider);
    return producsProvider.when(
      skipLoadingOnRefresh: false,
      data: (data) => Row(
        children: [
          Text(
            "Produtos: ${data.length}",
            style: const TextStyle(color: Colors.green),
          ),
          IconButton(
              onPressed: () {
                ref.invalidate(remoteProductProvider);
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      error: (_, error) => Row(
        children: [
          const Text(
            "Erro ao carregar produtos!",
            style: TextStyle(color: Colors.red),
          ),
          IconButton(
            onPressed: () {
              ref.invalidate(remoteProductProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      loading: () => const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      ),
    );
  }
}
