import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/order_check_provider.dart';

class OrderCheckListPage extends ConsumerStatefulWidget {
  const OrderCheckListPage({super.key});

  @override
  ConsumerState<OrderCheckListPage> createState() => _OrderCheckListPageState();
}

class _OrderCheckListPageState extends ConsumerState<OrderCheckListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pedidosAsync = ref.watch(orderCheckProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Conferência de Pedidos"),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(orderCheckProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: pedidosAsync.when(
        skipLoadingOnRefresh: false,
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(orderCheckProvider);
                  },
                  child: const Text("Tentar novamente"),
                ),
              ],
            ),
          ),
        ),
        data: (pedidos) {
          final filteredPedidos = _searchQuery.isEmpty
              ? pedidos
              : pedidos.where((p) {
                  final query = _searchQuery.toLowerCase();
                  return p.pedido.toLowerCase().contains(query) ||
                      p.cliente.toLowerCase().contains(query);
                }).toList();

          if (filteredPedidos.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearchField(),
                const Expanded(
                  child: Center(
                    child: Text("Nenhum pedido encontrado para conferência."),
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchField(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: filteredPedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = filteredPedidos[index];
                    return Card(
                      child: ListTile(
                  /* leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const FaIcon(
                      FontAwesomeIcons.clipboardList,
                      color: Colors.white,
                      size: 20,
                    ),
                  ), */
                  title: Text(
                    "Pedido ${pedido.pedido}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        pedido.cliente,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        "${pedido.municipio} - ${pedido.estado}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        "${pedido.itens.length} itens",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    context.push(
                      '/order_check/${pedido.pedido}',
                      extra: pedido,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  },
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar por pedido ou cliente...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value);
        },
      ),
    );
  }
}
