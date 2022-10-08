import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_transfer_cubit_state.dart';

class ProductTransferCubitCubit extends Cubit<ProductTransferCubitState> {
  ProductTransferCubitCubit() : super(ProductTransferCubitInitial());
}
