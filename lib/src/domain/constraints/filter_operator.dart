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
/// - $or - [Or]
/// - $and is a default behavior when multiple filters by the same column are applied.
///
/// Refer to [nest-paginate docs](https://www.npmjs.com/package/nestjs-paginate)
/// for more information about filters.
abstract class FilterOperator<TValue> {
  /// A map of filter representations used in `nestjs-paginate` to Dart types used in this package.
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

  /// An iterable of all filter representations used in `nestjs-paginate`.
  static Iterable<String> get representations => representationToType.keys;

  /// An iterable of types of all supported operators.
  static const Iterable<Type> all = {Eq, Not, Null, In, Gt, Lt, Btw, Ilike, Sw, Contains, Or};

  /// A text representation of this operator.
  /// Should not start with $, as it is inserted by the [toString].
  String get operator;

  /// A value of this filter operation.
  final TValue value;

  /// Creates a new [FilterOperator] with the given [value].
  const FilterOperator(this.value);

  /// Transforms the [value] into String for it to be inserted into its filter query parameter.
  ///
  /// Lists are joined by `,` when represented.
  /// Note that only $in and $contains usually take lists.
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

/// Represents the '$not:{other operator}'.
/// Takes a [FilterOperator] as its value.
///
/// ```dart
/// const Not(Eq(1)); // -> '$not:$eq:1'
/// ```
class Not<TValue> extends FilterOperator<FilterOperator<TValue>> {
  @override
  String get operator => 'not';

  const Not(super.value);
}

/// Represents the '$or:{other operator}'.
///
/// Takes a [FilterOperator] as its value.
///
/// When used, should be the topmost operator in the composition.
///
/// ```dart
/// const Or(Not(Eq(1))); // -> '$or:$not:$eq:1'
class Or<TValue> extends FilterOperator<FilterOperator<TValue>> {
  @override
  String get operator => 'or';

  const Or(super.value);
}

/// Represents the `$null` operator.
///
/// ```dart
/// const Not(Null()); // -> '$not:$null'
/// ```
class Null extends FilterOperator<Object> {
  @override
  String get operator => '';

  const Null() : super(0);

  @override
  String toString() => '\$null';
}

/// Represents the `$eq` operator.
///
/// ```dart
/// const Eq(10);      // -> '$eq:10'
/// const Not(Eq(10)); // -> '$not:$eq:10'
/// ```
class Eq<TValue> extends FilterOperator<TValue> {
  @override
  String get operator => 'eq';

  const Eq(super.value);
}

/// Represents the `$in` operator.
///
/// Takes a List<[TValue]> as its value.
/// The list will be joined with ','.
///
/// ```dart
/// const In([10, 15, 20]); // -> '$in:10,15,20'
/// ```
class In<TValue> extends FilterOperator<List<TValue>> {
  @override
  String get operator => 'in';

  const In(super.value);
}

/// A base class for [Gt] and [Lt] with the [_orEqual] parameter.
abstract class _ComparisonOperator<TValue> extends FilterOperator<TValue> {
  final bool _orEqual;

  const _ComparisonOperator(
    super.value, {
    required bool orEqual,
  }) : _orEqual = orEqual;

  @override
  String toString() => '\$$operator${_orEqual ? 'e' : ''}:${_representValue()}';
}

/// Represents the `$gt` and `$gte` operators.
///
/// By default, stands for `$gt`.
/// To change the behavior to `$gte`, provide the `orEqual: true` when creating.
///
/// ```dart
/// const Gt(5);                 // -> '$gt:5'
/// const Gt(-1, orEqual: true); // -> '$gte:-1'
/// ```
class Gt<TValue> extends _ComparisonOperator<TValue> {
  @override
  String get operator => 'gt';

  const Gt(
    super.value, {
    super.orEqual = false,
  });
}

/// Represents the `$lt` and `$lte` operators.
///
/// By default, stands for `$lt`.
/// To change the behavior to `$lte`, provide the `orEqual: true` when creating.
///
/// ```dart
/// const Lt(5);                 // -> '$lt:5'
/// const Lt(-1, orEqual: true); // -> '$lte:-1'
/// ```
class Lt<TValue> extends _ComparisonOperator<TValue> {
  @override
  String get operator => 'lt';

  const Lt(
    super.value, {
    super.orEqual = false,
  });
}

/// Represents the `$btw` operator.
///
/// Takes a pair of [TValue], for example:
/// ```dart
/// const Btw(20, 31);                     // -> '$btw:20,31'
/// const Btw('2022-02-02', '2022-02-10'); // -> '$btw:2022-02-02,2022-02-10'
/// ```
class Btw<TValue> extends FilterOperator<(TValue, TValue)> {
  @override
  String get operator => 'btw';

  const Btw(TValue a, TValue b) : super((a, b));

  @override
  String _representValue() {
    final (a, b) = value;

    return '$a,$b';
  }
}

/// Represents the `$ilike` operator.
///
/// ```dart
/// const Ilike('term'); // -> '$ilike:term'
/// ```
class Ilike<TValue> extends FilterOperator<TValue> {
  @override
  String get operator => 'ilike';

  const Ilike(super.value);
}

/// Represents the `$sw` operator, which stands for 'starts with'.
///
/// ```dart
/// const Sw('term'); // -> '$sw:term'
/// ```
class Sw<TValue> extends FilterOperator<TValue> {
  @override
  String get operator => 'sw';

  const Sw(super.value);
}

/// Represents the `$contains` operator.
/// Applicable when the filtered column is an array.
///
/// Filters the rows that contain all of the values in the list.
///
/// ```dart
/// const Contains(['admin']);              // -> '$contains:admin'
/// const Contains(['admin', 'moderator']); // -> '$contains:admin,moderator'
/// ```
class Contains<TValue> extends FilterOperator<List<TValue>> {
  @override
  String get operator => 'contains';

  const Contains(super.value);
}
