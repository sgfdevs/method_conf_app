extension IterableExtension<T> on Iterable<T> {
  Iterable<T> distinctBy(Object Function(T e) getCompareValue) {
    var idSet = <Object>{};
    var distinct = <T>[];
    for (var d in this) {
      if (idSet.add(getCompareValue(d))) {
        distinct.add(d);
      }
    }

    return distinct;
  }
}
