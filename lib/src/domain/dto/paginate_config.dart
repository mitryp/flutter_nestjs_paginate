// ignore_for_file: invalid_annotation_target

import 'dart:collection';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../constraints/filter_operator.dart';
import '../constraints/sort_order.dart';

part 'paginate_config.freezed.dart';

part 'paginate_config.g.dart';

const _defaultMaxLimit = 100;
const _defaultDefaultLimit = 20;

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
    @Default({})
    @JsonKey(fromJson: _sortableColumnsFromJson)
    Set<String> sortableColumns,

    /// A set of columns allowed for filtering by.
    ///
    /// If strict validation is enabled, adding a filter with the column not in the set will cause
    /// StateError. Otherwise, the filter will be ignored unless validation is disabled.
    @Default({})
    @JsonKey(fromJson: _filterableColumnsFromJson)
    Map<String, Set<Type>> filterableColumns,

    /// A maximum limit accepted by the server.
    /// A controller will not increase its limit over this value.
    @Default(_defaultMaxLimit) int maxLimit,

    /// A limit to be set by default.
    @Default(_defaultDefaultLimit) int defaultLimit,

    /// The default sorts applied when no sorts are configured in a controller.
    @Default({})
    @JsonKey(fromJson: _defaultSortByFromJson)
    Map<String, SortOrder> defaultSortBy,

    /// The default filters to be applied.
    /// This option is not supported by `nestjs-paginate` and purely the feature of this library.
    @Default({})
    @JsonKey(includeFromJson: false, includeToJson: false)
    Map<String, Set<FilterOperator>> defaultFilters,
  }) = _PaginateConfig;

  /// Deserializes [PaginateConfig] from JSON received from a NestJS server. It can handle edge
  /// cases, such as {'column': true} in `filterableColumns` and other TS moments.
  factory PaginateConfig.fromJson(Map<String, Object?> json) =>
      _$PaginateConfigFromJson(json);
}

Map<String, SortOrder> _defaultSortByFromJson(List<dynamic> value) =>
    Map.fromEntries(
      value.cast<List>().map((sort) {
        final [field as String, orderName as String] = sort;
        final order = SortOrder.fromName(orderName);

        return MapEntry(field, order);
      }),
    );

Set<String> _sortableColumnsFromJson(List<dynamic> value) =>
    value.cast<String>().toSet();

Map<String, Set<Type>> _filterableColumnsFromJson(
  Map<String, dynamic> filters,
) =>
    filters.map(
      (field, value) {
        final List operators;

        if (value is List) {
          operators = value;
        } else if (value is bool) {
          // to support 'column: true' in PaginateConfig in nestjs-paginate
          operators = value
              ? FilterOperator.representations.toList(growable: false)
              : const [];
        } else {
          throw StateError(
            'Unsupported syntax for filterableColumns: $value\n'
            'If this happened and you did no modifications to `nestjs-paginate` behavior, '
            'consider reporting this issue including your user-facing configuration: '
            'https://github.com/mitryp/flutter_nestjs_paginate/issues/new/choose',
          );
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
