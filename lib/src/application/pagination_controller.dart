import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../domain/constraints/filter_operator.dart';
import '../domain/constraints/sort_order.dart';
import '../domain/dto/paginate_config.dart';
import '../domain/typedefs.dart';

/// A listenable controller for pagination view, compatible with `nestjs-paginate` API.
///
/// Currently, it does not support `select` query, as using it would break the majority of Dart
/// models.
///
/// Refer to the [PaginationController.new] documentation for more information.
abstract interface class PaginationController with ChangeNotifier {
  /// A [PaginateConfig] of this controller.
  PaginateConfig? get paginateConfig;

  /// Getter and setter for maximum items per page.
  ///
  /// When changed, the listeners will be notified.
  int get limit;

  /// Getter and setter for maximum items per page.
  ///
  /// When changed, the listeners will be notified.
  set limit(int value);

  /// Getter and setter for the currently shown page.
  ///
  /// When changed, the listeners will be notified.
  int get page;

  /// Getter and setter for the currently shown page.
  ///
  /// When changed, the listeners will be notified.
  set page(int value);

  /// Getter and setter for the search query.
  ///
  /// When changed, the listeners will be notified.
  Object? get search;

  /// Getter and setter for the search query.
  ///
  /// When changed, the listeners will be notified.
  set search(Object? value);

  /// An unmodifiable map of the filters applied in the query.
  /// Has the following structure:
  /// ```dart
  /// filters = {
  ///   'column': { FilterOperator, FilterOperator, ... },
  ///   ...
  /// }
  /// ```
  Map<String, Set<FilterOperator>> get filters;

  /// An unmodifiable map of the sorts applied in the query.
  Map<String, SortOrder> get sorts;

  /// Creates a new [PaginationController].
  ///
  /// The configuration includes:
  /// - [sortableColumns] - names of the entity fields that can be sorted by;
  /// - [filterableColumns] - names of the entity fields that can be filtered by;
  /// - [validateColumns] - whether this controller should validate the sort and filter columns
  /// when adding them;
  /// - [strictValidation] - if true, failed column validation will throw [StateError].
  /// Otherwise, when the validation is enabled, it will silently prevent invalid columns from being
  /// added.
  ///
  /// Optional initial values can be provided:
  /// - [limit] - defines the maximum amount of entries per page;
  /// - [page] - the current page;
  /// - [sorts] - sorts of the query;
  /// - [filters] - filters of the query;
  /// - [search] - the search query.
  factory PaginationController({
    bool validateColumns,
    bool strictValidation,
    int limit,
    int page,
    Map<String, SortOrder> sorts,
    Map<String, Set<FilterOperator>> filters,
    Object? search,
    PaginateConfig? paginateConfig,
  }) = _PaginationController;

  /// Adds sort query by the given [field] with the given [order] to the query.
  ///
  /// If the sort with the given field is already present, the value will be overwritten.
  /// When changed, the listeners will be notified.
  ///
  /// If strict validation is enabled, providing an unsupported [field] will cause a [StateError].
  /// Otherwise, the sort will not be added, unless validation is disabled.
  void addSort(String field, SortOrder order);

  /// Removes a sort query by the given [field].
  ///
  /// When changed, the listeners will be notified.
  void removeSort(String field);

  /// Removes all sorts from the query.
  /// If the sort set is not empty, the listeners are notified.
  void clearSorts();

  /// Adds a filter by the given [field] with the given [operator] to the query.
  ///
  /// Supports multiple filters by the same field.
  /// When changed, the listeners will be notified.
  ///
  /// If strict validation is enabled, providing an unsupported filter field will cause a
  /// [StateError].
  /// Otherwise, the filter will not be added, unless validation is disabled.
  void addFilter(String field, FilterOperator operator);

  /// Removes all filters by the given [field] from the query.
  /// If the [operator] is given, removes only the filter containing the operator.
  ///
  /// When changed, the listeners will be notified.
  void removeFilter(String field, [FilterOperator? operator]);

  /// Removes all filters from the query.
  /// If the filter set is not empty, the listeners are notified.
  void clearFilters();

  /// Performs the operation/operations on this controller without notifying listeners.
  /// Use it to replace filters or sorts, or change multiple parameters at once without unnecessary
  /// network requests.
  ///
  /// All operations must be performed inside the provided function.
  ///
  /// If [notifyAfter] is set to true, listeners will be notified after the function is executed.
  void silently(void Function(PaginationController controller) fn, {bool notifyAfter});

  /// Creates a [QueryParams] map from the parameters of this [PaginationController].
  QueryParams toMap();
}

class _PaginationController with ChangeNotifier implements PaginationController {
  // controller-specific validation options
  /// Whether this controller should validate the columns used in [addSort] and [addFilter].
  final bool _validateColumns;

  /// Whether this controller should throw [StateError] when column validation fails.
  /// Has no effect if [_validateColumns] is set to false.
  final bool _strictValidation;

  /// Whether this controller notifies its listeners.
  /// Used internally.
  bool _doesNotify = true;

  // private pagination options

  @override
  final PaginateConfig? paginateConfig;

  int _limit;

  int _page;

  Object? _search;

  final Map<String, SortOrder> _sorts = {};

  final Map<String, Set<FilterOperator>> _filters = {};

  // user-facing members

  @override
  int get limit => _limit;

  @override
  set limit(int value) {
    if (value == limit) return;

    _notifyOf(() => _limit = value);
  }

  @override
  int get page => _page;

  @override
  set page(int value) {
    if (value == page) return;

    _notifyOf(() => _page = value);
  }

  @override
  Object? get search => _search;

  @override
  set search(Object? value) {
    if (value == search) return;
    _notifyOf(() => _search = value);
  }

  @override
  Map<String, SortOrder> get sorts => UnmodifiableMapView(_sorts);

  @override
  void addSort(String field, SortOrder order) {
    if (!_isSortValid(field)) {
      return;
    }

    _sorts[field] = order;

    notifyListeners();
  }

  @override
  void removeSort(String field, {bool notify = true}) {
    if (_sorts.remove(field) == null) {
      return;
    }

    if (notify) notifyListeners();
  }

  @override
  void clearSorts() {
    if (_sorts.isEmpty) return;

    _notifyOf(_sorts.clear);
  }

  @override
  Map<String, Set<FilterOperator>> get filters =>
      UnmodifiableMapView(_filters.map((key, value) => MapEntry(key, UnmodifiableSetView(value))));

  @override
  void addFilter(String field, FilterOperator operator) {
    if (!_isFilterValid(field, operator)) {
      return;
    }

    var wasAdded = false;

    _filters.update(
      field,
      (existing) {
        wasAdded = existing.add(operator);
        return existing;
      },
      ifAbsent: () => {operator},
    );

    if (wasAdded) notifyListeners();
  }

  @override
  void removeFilter(String field, [FilterOperator? operator]) {
    if (operator == null) {
      if (_filters.remove(field) != null) notifyListeners();
      return;
    }

    final filters = _filters[field];

    if (filters == null || !filters.remove(operator)) {
      return;
    }

    notifyListeners();
  }

  @override
  void clearFilters() {
    if (_filters.isEmpty) return;

    _notifyOf(_filters.clear);
  }

  @override
  void silently(void Function(PaginationController controller) fn, {bool notifyAfter = false}) {
    _doesNotify = false;

    fn(this);

    _doesNotify = true;
    if (notifyAfter) notifyListeners();
  }

  @override
  QueryParams toMap() {
    final search = this.search;

    return {
      'limit': limit,
      'page': page,
      if (search != null) 'search': search,
      if (_sorts.isNotEmpty)
        'sortBy': _sorts.entries
            .map((e) => '${e.key}:${e.value.name.toUpperCase()}')
            .toList(growable: false),
      ..._filters.map(
        (field, operators) =>
            MapEntry('filter.$field', operators.map((op) => '$op').toList(growable: false)),
      ),
    };
  }

  _PaginationController({
    int? limit,
    int page = 1,
    Map<String, SortOrder> sorts = const {},
    Map<String, Set<FilterOperator>> filters = const {},
    Object? search,
    bool validateColumns = true,
    bool strictValidation = false,
    this.paginateConfig,
  })  : _limit = limit ?? paginateConfig?.defaultLimit ?? 20,
        _page = page,
        _search = search,
        _validateColumns = validateColumns,
        _strictValidation = strictValidation {
    _filters.addAll(filters);

    _sorts.addAll(sorts);
    if (sorts.isEmpty) {
      final defaultSort = paginateConfig?.defaultSortBy;
      if (defaultSort != null) {
        _sorts.addAll(defaultSort);
      }
    }
  }

  @override
  void notifyListeners() {
    if (_doesNotify) super.notifyListeners();
  }

  bool _isSortValid(String column) {
    if (!_validateColumns || (paginateConfig?.sortableColumns ?? const {}).contains(column)) {
      return true;
    }

    if (!_strictValidation) {
      return false;
    }

    throw StateError('Sort by $column is not allowed by PaginationController configuration.');
  }

  bool _isFilterValid(String column, FilterOperator operator) {
    final filterableColumns = paginateConfig?.filterableColumns ?? const {};

    if (!_validateColumns || (filterableColumns[column]?.contains(operator.runtimeType) ?? false)) {
      return true;
    }

    if (!_strictValidation) {
      return false;
    }

    throw StateError(
      'Filter ${operator.runtimeType} by $column '
      'is not allowed by PaginationController configuration.',
    );
  }

  void _notifyOf(void Function() fn) {
    fn();
    notifyListeners();
  }
}
