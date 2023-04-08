import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:nexus_estoque/core/error/failure.dart';
import 'package:nexus_estoque/features/picking_route/data/model/picking_route_model.dart';
import 'package:nexus_estoque/features/picking_route/data/repositories/picking_route_repository.dart';

part 'picking_routes_state.dart';

class PickingRoutesCubit extends Cubit<PickingRoutesState> {
  final PickingRouteRepository repository;

  PickingRoutesCubit(this.repository) : super(PickingRoutesInitial()) {
    fetchPickingRoutes();
  }

  void setRoute(String route) {
    if (state is PickingRoutesLoaded) {
      final newState = state as PickingRoutesLoaded;
      emit(PickingRoutesLoading());
      emit(
        PickingRoutesLoaded(
            pickingRoutes: newState.pickingRoutes,
            routeSelected: route,
            shippingSelected: ''),
      );
    }
  }

  void fetchPickingRoutes() async {
    String selectedRoute = '';

    if (state is PickingRoutesLoaded) {
      final newState = state as PickingRoutesLoaded;
      selectedRoute = newState.routeSelected;
    }
    emit(PickingRoutesLoading());
    final result = await repository.fetchPickingList();
    if (result.isRight()) {
      result.fold((l) => null, (r) {
        emit(
          PickingRoutesLoaded(
              pickingRoutes: r,
              routeSelected: selectedRoute,
              shippingSelected: ''),
        );
      });
    } else {
      result.fold((l) => emit(PickingRoutesError(l)), (r) => null);
    }
  }
}
