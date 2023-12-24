/// A family of filter operators and suffixes used in pagination filtering.
///
/// Currently, the following operators are supported:
///
/// - $eq - [Eq]
/// - $not - [Not]
/// - $null - [Null]
/// - $in - [In]
/// - $gt, $gte - [Gt]
/// - $lt, $lte - [Lt]
/// - $btw - [Btw]
/// - $ilike - [Ilike]
/// - $sw - [Sw]
/// - $contains - [Contains]
///
/// Refer to [nest-paginate docs](https://www.npmjs.com/package/nestjs-paginate)
/// for more information about filters.
abstract class FilterOperator<TValue> {
  static const Map<String, Type> representationToType = {
    '\$eq': Eq,
    '\$not': Not,
    '\$null': Null,
    '\$in': In,
    '\$gt': Gt,
    '\$gte': Gt,
    '\$lt': Lt,
    '\$lte': Lt,
    '\$btw': Btw,
    '\$ilike': Ilike,
    '\$sw': Sw,
    '\$contains': Contains,
  };

  static Iterable<String> get representations => representationToType.keys;

  static Map<Type, String> get typeToRepresentation =>
      representationToType.map((key, value) => MapEntry(value, key));

  /// A text representation of the operator.
  /// Should not start with $, as it is normally inserted by [toString].
  String get operator;

  /// A value of this filter operation.
  final TValue value;

  /// Creates a new [FilterOperator] with the given [value].
  const FilterOperator(this.value);

  /// Transforms the [value] into String for it to be ready for the operation to be built.
  ///
  /// Lists are joined by `,` when represented.
  /// Note that only $in and $contains normally take lists.
  String _representValue() {
    final value = this.value;

    if (value is List) {
      return value.join(',');
    }

    return value.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FilterOperator &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          operator == other.operator;

  @override
  int get hashCode => value.hashCode ^ operator.hashCode;

  @override
  String toString() => '\$$operator:${_representValue()}';
}

class Not<TValue> extends FilterOperator<FilterOperator<TValue>> {
  @override
  String get operator => 'not';

  const Not(super.value);
}

class Or<TValue> extends FilterOperator<FilterOperator<TValue>> {
  @override
  String get operator => 'or';

  const Or(super.value);
}

class Null extends FilterOperator<Object> {
  @override
  String get operator => '';

  const Null() : super(0);

  @override
  String toString() => '\$null';
}

class Eq<TValue> extends FilterOperator<TValue> {
  @override
  String get operator => 'eq';

  const Eq(super.value);
}

class In<TValue> extends FilterOperator<List<TValue>> {
  @override
  String get operator => 'in';

  const In(super.value);
}

abstract class _ComparisonOperator<TValue> extends FilterOperator<TValue> {
  final bool _orEqual;

  const _ComparisonOperator(
    super.value, {
    required bool orEqual,
  }) : _orEqual = orEqual;

  @override
  String toString() => '\$$operator${_orEqual ? 'e' : ''}:${_representValue()}';
}

class Gt<TValue> extends _ComparisonOperator<TValue> {
  @override
  String get operator => 'gt';

  const Gt(
    super.value, {
    super.orEqual = false,
  });
}

class Lt<TValue> extends _ComparisonOperator<TValue> {
  @override
  String get operator => 'lt';

  const Lt(
    super.value, {
    super.orEqual = false,
  });
}

class Btw<TValue> extends FilterOperator<(TValue, TValue)> {
  @override
  String get operator => 'btw';

  const Btw(super.value);
}

class Ilike<TValue> extends FilterOperator<TValue> {
  @override
  String get operator => 'ilike';

  const Ilike(super.value);
}

class Sw<TValue> extends FilterOperator<TValue> {
  @override
  String get operator => 'sw';

  const Sw(super.value);
}

class Contains<TValue> extends FilterOperator<List<TValue>> {
  @override
  String get operator => 'contains';

  const Contains(super.value);
}
