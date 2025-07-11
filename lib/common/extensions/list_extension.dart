extension LinqExtensions<T> on Iterable<T> {
  /// Returns a list with elements that are in the original list but not in [other].
  /// An optional filter function can be applied.
  Iterable<T> except(Iterable<T> other, {bool Function(T value)? filter}) {
    return where((e) => !other.contains(e) && (filter == null || filter(e)));
  }

  /// Returns elements in the original list that are NOT in [other], using a custom comparator.
  /// The optional [filter] function determines how elements are compared.
  Iterable<T> exceptCompare<U>(Iterable<U> other, bool Function(T value1, U value2) filter) sync* {
    for (var element in this) {
      bool found = other.any((otherElement) => filter(element, otherElement));
      if (!found) yield element;
    }
  }

  T? firstWhereOrNull(bool Function(T element) test) {
    for (T element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  /// Returns a list with elements that are both in the original list and in [other].
  /// An optional filter function can be applied.
  Iterable<T> intersect(Iterable<T> other, {bool Function(T value)? filter}) {
    return where((e) => other.contains(e) && (filter == null || filter(e)));
  }

  /// Returns a list with elements that are both in the original list and in [other].
  /// The optional [filter] function determines how elements are compared.
  Iterable<T> intersectCompare<U>(Iterable<U> other, bool Function(T value1, U value2) filter) sync* {
    for (var element in this) {
      bool found = other.any((otherElement) => filter(element, otherElement));
      if (found) yield element;
    }
  }

  /// Returns the first element that satisfies the [predicate] or null if none is found.
  T? firstOrDefault([bool Function(T value)? predicate]) {
    return predicate == null ? (isEmpty ? null : first) : firstWhere(predicate, orElse: () => null as T);
  }

  /// Returns the last element that satisfies the [predicate] or null if none is found.
  T? lastOrDefault([bool Function(T value)? predicate]) {
    return predicate == null ? (isEmpty ? null : last) : lastWhere(predicate, orElse: () => null as T);
  }

  /// Returns the single element that satisfies the [predicate] or null if none/multiple found.
  T? singleOrDefault([bool Function(T value)? predicate]) {
    final filtered = predicate == null ? this : where(predicate);
    return filtered.length == 1 ? filtered.first : null;
  }

  /// Reduces the list using a function that accumulates the value.
  U aggregate<U>(U seed, U Function(U accumulator, T element) func) {
    U result = seed;
    for (var element in this) {
      result = func(result, element);
    }
    return result;
  }

  /// Returns true if all elements satisfy the [predicate].
  bool all(bool Function(T value) predicate) {
    return every(predicate);
  }

  /// Returns true if any element satisfies the [predicate] or if the list is not empty.
  bool any([bool Function(T value)? predicate]) {
    return predicate == null ? isNotEmpty : where(predicate).isNotEmpty;
  }

  num sum([num Function(T value)? selector, num initialValue = 0]) {
    if (selector == null) {
      return fold(initialValue, (acc, element) => acc + (element as num));
    } else {
      return fold(initialValue, (acc, element) => acc + selector(element));
    }
  }

  /// Returns distinct elements by a specific key selector.
  Iterable<T> distinctBy<K>(K Function(T value) keySelector) {
    final seenKeys = <K>{};
    return where((element) => seenKeys.add(keySelector(element)));
  }

  /// Groups elements by a key selector.
  Map<K, Iterable<T>> groupBy<K>(K Function(T value) keySelector) {
    final map = <K, List<T>>{};
    for (var element in this) {
      (map[keySelector(element)] ??= []).add(element);
    }
    return map;
  }

  /// Sorts the list in ascending order by a key selector.
  Iterable<T> orderBy<K extends Comparable<K>>(K Function(T value) keySelector) {
    return [...this]..sort((a, b) => keySelector(a).compareTo(keySelector(b)));
  }

  /// Sorts the list in descending order by a key selector.
  Iterable<T> orderByDescending<K extends Comparable<K>>(K Function(T value) keySelector) {
    return [...this]..sort((a, b) => keySelector(b).compareTo(keySelector(a)));
  }

  /// Takes elements while the [predicate] is true.
  Iterable<T> takeWhile(bool Function(T value) predicate) sync* {
    for (var element in this) {
      if (!predicate(element)) break;
      yield element;
    }
  }

  /// Skips elements while the [predicate] is true.
  Iterable<T> skipWhile(bool Function(T value) predicate) sync* {
    bool skipping = true;
    for (var element in this) {
      if (skipping && !predicate(element)) {
        skipping = false;
      }
      if (!skipping) yield element;
    }
  }

  /// Combines two iterables into a single iterable using a provided function.
  Iterable<R> zip<U, R>(Iterable<U> other, R Function(T first, U second) combiner) sync* {
    var iter1 = iterator;
    var iter2 = other.iterator;

    while (iter1.moveNext() && iter2.moveNext()) {
      yield combiner(iter1.current, iter2.current);
    }
  }

  /// Converts the list to a Map using a key selector.
  Map<K, T> toDictionary<K>(K Function(T value) keySelector) {
    return {for (var element in this) keySelector(element): element};
  }

  /// Lazily splits the iterable into chunks of the specified [size].
  Iterable<List<T>> chunk(int size) sync* {
    if (size <= 0) throw ArgumentError("Size must be greater than 0");

    var iterator = this.iterator;
    while (iterator.moveNext()) {
      List<T> chunk = [];
      do {
        chunk.add(iterator.current);
      } while (chunk.length < size && iterator.moveNext());

      yield chunk;
    }
  }

  /// Returns a portion of the iterable as a new list, similar to `List.sublist(start, end)`.
  Iterable<T> sublist(int start, [int? end]) sync* {
    if (start < 0 || (end != null && end < start)) {
      throw ArgumentError("Invalid sublist range: start=$start, end=$end");
    }

    int index = 0;

    for (var item in this) {
      if (index >= start && (end == null || index < end)) {
        yield item;
      }
      if (end != null && index >= end) break;
      index++;
    }
  }
}
