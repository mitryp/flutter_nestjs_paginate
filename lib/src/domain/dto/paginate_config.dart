// ignore_for_file: invalid_annotation_target

import 'dart:collection';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../constraints/filter_operator.dart';
import '../constraints/sort_order.dart';

part 'paginate_config.freezed.dart';

part 'paginate_config.g.dart';

/// A class mirroring the client-facing side of PaginateConfig of `nestjs-paginate`.
///
/// It omits backend- and database-specific fields, while preserving those needed on the frontend.
///
/// The config from the backend can be deserialized used [PaginateConfig.fromJson] which supports
/// its syntax.
@Freezed(toJson: false)
class PaginateConfig with _$PaginateConfig {
  const factory PaginateConfig({
    /// A set of columns allowed to be used in sorts.
    ///
    /// If strict validation is enabled, adding a sort with the column not in the set will cause
    /// StateError. Otherwise, the sort will be ignored unless validation is disabled.
    @Default({}) @JsonKey(fromJson: _sortableColumnsFromJson) Set<String> sortableColumns,

    /// A set of columns allowed for filtering by.
    ///
    /// If strict validation is enabled, adding a filter with the column not in the set will cause
    /// StateError. Otherwise, the filter will be ignored unless validation is disabled.
    @Default({})
    @JsonKey(fromJson: _filterableColumnsFromJson)
    Map<String, Set<Type>> filterableColumns,

    /// A maximum limit accepted by the server.
    /// A controller will not increase its limit over this value.
    @Default(100) int maxLimit,

    /// A limit to be set by default.
    @Default(20) int defaultLimit,

    /// The default sorts applied when no sorts are configured in a controller.
    @JsonKey(fromJson: _defaultSortByFromJson) Map<String, SortOrder>? defaultSortBy,
  }) = _PaginateConfig;

  /// Deserializes [PaginateConfig] from JSON received from a NextJS server. It can handle edge
  /// cases, such as {'column': true} in `filterableColumns` and other TS moments.
  factory PaginateConfig.fromJson(Map<String, Object?> json) => _$PaginateConfigFromJson(json);
}

Map<String, SortOrder>? _defaultSortByFromJson(List<dynamic> value) => Map.fromEntries(
      value.cast<List>().map((sort) {
        final [field as String, orderName as String] = sort;
        final order = SortOrder.fromName(orderName);

        return MapEntry(field, order);
      }),
    );

Set<String> _sortableColumnsFromJson(List<dynamic> value) => value.cast<String>().toSet();

Map<String, Set<Type>> _filterableColumnsFromJson(Map<String, dynamic> filters) => filters.map(
      (field, value) {
        final List operators;

        if (value is List) {
          operators = value;
        } else if (value is bool) {
          operators = FilterOperator.representations.toList(growable: false);
        } else {
          throw StateError('unsupported syntax for filterableColumns: $value');
        }

        return MapEntry(
          field,
          UnmodifiableSetView(
            operators
                .cast<String>()
                .map((op) => FilterOperator.representationToType[op])
                .nonNulls
                .toSet(),
          ),
        );
      },
    );
