import 'dart:collection';
import 'dart:math';

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
  PaginateConfig get paginateConfig;

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
  /// - [paginateConfig] - refer to the [PaginateConfig] docs;
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
  ///
  /// Note that no columns are allowed for sorting and filtering by default, so consider providing
  /// the [paginateConfig].
  factory PaginationController({
    bool validateColumns,
    bool strictValidation,
    int limit,
    int page,
    Map<String, SortOrder> sorts,
    Map<String, Set<FilterOperator>> filters,
    Object? search,
    PaginateConfig paginateConfig,
  }) = PaginationControllerImpl;

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

  /// Removes all sorts from the query and sets [filters] to the [paginateConfig.defaultSortBy].
  /// If no config is present, an empty map will be used instead.
  ///
  /// If the sort set is not empty, the listeners are notified.
  ///
  /// If the [resetDefaults] is set to true, the contents of the respective
  /// [PaginateConfig.defaultSortBy] will be added to the sort list.
  void clearSorts({bool resetDefaults = false});

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

  /// Performs the operations on this controller without notifying listeners.
  /// Use it to replace filters or sorts, or change multiple parameters at once without unnecessary
  /// network requests.
  ///
  /// All operations must be performed inside the provided function.
  ///
  /// If [notifyAfter] is set to true, listeners will be notified after the function is executed.
  void silently(
    void Function(PaginationController controller) fn, {
    bool notifyAfter,
  });

  /// Creates a [QueryParams] map from the parameters of this [PaginationController].
  QueryParams toMap();
}

@visibleForTesting
class PaginationControllerImpl
    with ChangeNotifier
    implements PaginationController {
  /// Whether this controller should validate the columns used in [addSort] and [addFilter].
  final bool _validateColumns;

  /// Whether this controller should throw [StateError] when column validation fails.
  /// Has no effect if [_validateColumns] is set to false.
  final bool _strictValidation;

  /// Whether this controller notifies its listeners.
  /// Used internally.
  @visibleForTesting
  bool doesNotify = true;

  int _limit;

  int _page;

  Object? _search;

  final Map<String, SortOrder> _sorts = {};

  final Map<String, Set<FilterOperator>> _filters = {};

  // user-facing members
  @override
  final PaginateConfig paginateConfig;

  @override
  int get limit => _limit;

  @override
  set limit(int value) {
    if (value == limit) {
      return;
    }

    _notifyOf(() => _limit = min(value, paginateConfig.maxLimit));
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
    if (!_isSortValid(field) || _sorts[field] == order) {
      return;
    }

    _notifyOf(() => _sorts[field] = order);
  }

  @override
  void removeSort(String field) {
    if (_sorts.remove(field) == null) {
      return;
    }

    notifyListeners();
  }

  @override
  void clearSorts({bool resetDefaults = false}) {
    bool wasChanged = false;

    if (_sorts.isNotEmpty) {
      _sorts.clear();
      wasChanged = true;
    }

    if (resetDefaults) {
      _sorts.addAll(paginateConfig.defaultSortBy);
      wasChanged |= paginateConfig.defaultSortBy.isNotEmpty;
    }

    if (wasChanged) notifyListeners();
  }

  @override
  Map<String, Set<FilterOperator>> get filters => UnmodifiableMapView(
        _filters.map((key, value) => MapEntry(key, UnmodifiableSetView(value))),
      );

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
      ifAbsent: () {
        wasAdded = true;
        return {operator};
      },
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
  void silently(
    void Function(PaginationController controller) fn, {
    bool notifyAfter = false,
  }) {
    doesNotify = false;

    fn(this);

    doesNotify = true;
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
      ...(_filters..removeWhere((key, value) => value.isEmpty)).map(
        (field, operators) => MapEntry(
          'filter.$field',
          operators.map((op) => '$op').toList(growable: false),
        ),
      ),
    };
  }

  PaginationControllerImpl({
    int? limit,
    int page = 1,
    Map<String, SortOrder> sorts = const {},
    Map<String, Set<FilterOperator>> filters = const {},
    Object? search,
    bool validateColumns = true,
    bool strictValidation = false,
    this.paginateConfig = const PaginateConfig(),
  })  : _limit = limit ?? paginateConfig.defaultLimit,
        _page = page,
        _search = search,
        _validateColumns = validateColumns,
        _strictValidation = strictValidation {
    _filters.addAll(filters);

    _sorts.addAll(sorts);
    if (sorts.isEmpty) {
      _sorts.addAll(paginateConfig.defaultSortBy);
    }
  }

  @override
  void notifyListeners() {
    if (doesNotify) super.notifyListeners();
  }

  bool _isSortValid(String column) {
    if (!_validateColumns || paginateConfig.sortableColumns.contains(column)) {
      return true;
    }

    if (!_strictValidation) {
      return false;
    }

    throw StateError(
      'Sort by $column is not allowed by PaginationController configuration.',
    );
  }

  bool _isFilterValid(String column, FilterOperator operator) {
    final filterableColumns = paginateConfig.filterableColumns;

    if (!_validateColumns ||
        (filterableColumns[column]?.contains(operator.runtimeType) ?? false)) {
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
