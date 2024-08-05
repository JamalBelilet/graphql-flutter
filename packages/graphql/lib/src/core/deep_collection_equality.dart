import 'package:collection/collection.dart';

class DeepCollectionEqualityOpt implements Equality<Object?> {
  final Equality<Object?> _base;
  final bool _unordered;

  const DeepCollectionEqualityOpt(
      [Equality<Object?> base = const DefaultEquality()])
      : _base = base,
        _unordered = false;

  const DeepCollectionEqualityOpt.unordered(
      [Equality<Object?> base = const DefaultEquality()])
      : _base = base,
        _unordered = true;

  @override
  bool equals(Object? a, Object? b) {
    if (identical(a, b)) {
      return true;
    }
    if (a == b) {
      return true;
    }
    if (a is Map) {
      if (b is! Map) {
        return false;
      }
      if (a.length != b.length) return false;
      for (var key in a.keys) {
        if (!b.containsKey(key)) return false;
        if (!equals(a[key], b[key])) return false;
      }
      return true;
    }
    if (a is List) {
      if (b is! List) {
        return false;
      }
      final length = a.length;
      if (length != b.length) return false;
      for (var i = 0; i < length; i++) {
        if (!equals(a[i], b[i])) return false;
      }
      return true;
    }
    return false;
  }

  @override
  int hash(Object? o) {
    if (o == null) return 0;

    if (o is Set) {
      return _unordered
          ? UnorderedIterableEquality(_base).hash(o)
          : SetEquality(_base).hash(o);
    }

    if (o is Map) return MapEquality(keys: _base, values: _base).hash(o);
    if (o is Iterable) {
      return _unordered
          ? UnorderedIterableEquality(_base).hash(o)
          : IterableEquality(_base).hash(o);
    }

    return _base.hash(o);
  }

  @override
  bool isValidKey(Object? o) =>
      o is Iterable || o is Map || _base.isValidKey(o);
}
