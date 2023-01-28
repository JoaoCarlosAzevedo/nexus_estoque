class ProductArg {
  String product;
  String warehouse;
  ProductArg({
    required this.product,
    required this.warehouse,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductArg &&
        other.product == product &&
        other.warehouse == warehouse;
  }

  @override
  int get hashCode => product.hashCode ^ warehouse.hashCode;
}
