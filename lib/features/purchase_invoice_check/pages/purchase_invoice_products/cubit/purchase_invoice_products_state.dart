// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'purchase_invoice_products_cubit.dart';

abstract class PurchaseInvoiceProductsState extends Equatable {
  const PurchaseInvoiceProductsState();

  @override
  List<Object> get props => [];
}

class PurchaseInvoiceProductsLoading extends PurchaseInvoiceProductsState {}

class PurchaseInvoiceProductsLChecking extends PurchaseInvoiceProductsState {
  final bool show;
  final String? barcode;
  final PurchaseInvoiceProduct? product;
  final List<PurchaseInvoice> invoices;

  const PurchaseInvoiceProductsLChecking({
    required this.show,
    required this.barcode,
    required this.product,
    required this.invoices,
  });
}

class PurchaseInvoiceProductsSuccess extends PurchaseInvoiceProductsState {}

class PurchaseInvoiceProductsError extends PurchaseInvoiceProductsState {
  final Failure error;
  const PurchaseInvoiceProductsError({
    required this.error,
  });
}
