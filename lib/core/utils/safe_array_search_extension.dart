extension IterableX<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    T? firstItem;
    for (var item in this) {
      if (test(item)) {
        firstItem = item;
        break;
      }
    }
    return firstItem;
  }
}
