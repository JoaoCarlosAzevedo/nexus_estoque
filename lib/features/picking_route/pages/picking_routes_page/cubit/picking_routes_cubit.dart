import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/picking/data/model/picking_order_model.dart';
import 'package:nexus_estoque/features/picking_route/data/model/picking_route_model.dart';
import 'package:nexus_estoque/features/picking_route/data/model/shipping_model.dart';
import 'package:nexus_estoque/features/picking_route/data/repositories/picking_route_repository.dart';

part 'picking_routes_state.dart';

class PickingRoutesCubit extends Cubit<PickingRoutesState> {
  final PickingRouteRepository repository;

  PickingRoutesCubit(this.repository) : super(PickingRoutesInitial()) {
    fetchPickingRoutes();
  }

  void setRoute(PickingRouteModel? route) {
    if (state is PickingRoutesLoaded) {
      final newState = state as PickingRoutesLoaded;
      emit(PickingRoutesLoading());
      emit(
        PickingRoutesLoaded(
            pickingRoutes: newState.pickingRoutes,
            routeSelected: route,
            shippingSelected: null,
            pickingOrderSelected: null),
      );
    }
  }

  void setShipping(ShippingModel? shippingCode) {
    if (state is PickingRoutesLoaded) {
      final newState = state as PickingRoutesLoaded;
      emit(PickingRoutesLoading());
      emit(
        PickingRoutesLoaded(
            pickingRoutes: newState.pickingRoutes,
            routeSelected: newState.routeSelected,
            shippingSelected: shippingCode,
            pickingOrderSelected: null),
      );
    }
  }

  void setPickingOrder(PickingOrder? order) {
    if (state is PickingRoutesLoaded) {
      final newState = state as PickingRoutesLoaded;
      emit(PickingRoutesLoading());
      emit(
        PickingRoutesLoaded(
            pickingRoutes: newState.pickingRoutes,
            routeSelected: newState.routeSelected,
            shippingSelected: newState.shippingSelected,
            pickingOrderSelected: order),
      );
    }
  }

  void fetchPickingRoutes() async {
    PickingRouteModel? routeSelected;
    ShippingModel? shippingSelected;
    PickingOrder? pickingOrderSelected;
    PickingRouteModel? newRouteSelected;
    ShippingModel? newShippingSelected;
    PickingOrder? newPickingOrderSelected;

    if (state is PickingRoutesLoaded) {
      final oldState = state as PickingRoutesLoaded;
      routeSelected = oldState.routeSelected;
      shippingSelected = oldState.shippingSelected;
      pickingOrderSelected = oldState.pickingOrderSelected;
    }

    emit(PickingRoutesLoading());
    final result = await repository.fetchPickingList();
    if (result.isRight()) {
      result.fold((l) => null, (r) {
        //confere o estado atual selecionao na hora de atualizar
        if (routeSelected != null) {
          newRouteSelected = r.firstWhereOrNull(
              (element) => element.codRota == routeSelected!.codRota);
          if (shippingSelected != null) {
            newShippingSelected = newRouteSelected!.cargas.firstWhere(
                (element) => element.codCarga == shippingSelected!.codCarga);
          }

          if (pickingOrderSelected != null) {
            newPickingOrderSelected = newShippingSelected!.pedidos
                .firstWhereOrNull((element) =>
                    element.pedido == pickingOrderSelected!.pedido);
          }
        }

        emit(
          PickingRoutesLoaded(
              pickingRoutes: r,
              routeSelected: newRouteSelected,
              shippingSelected: newShippingSelected,
              pickingOrderSelected: newPickingOrderSelected),
        );
      });
    } else {
      result.fold((l) => emit(PickingRoutesError(l)), (r) => null);
    }
  }
}
