// ignore_for_file: invalid_annotation_target

import 'dart:collection';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../constraints/filter_operator.dart';
import '../constraints/sort_order.dart';

part 'paginate_config.freezed.dart';

part 'paginate_config.g.dart';

@Freezed(toJson: false)
class PaginateConfig with _$PaginateConfig {
  const factory PaginateConfig({
    @Default({}) @JsonKey(fromJson: _sortableColumnsFromJson) Set<String> sortableColumns,
    @Default({})
    @JsonKey(fromJson: _filterableColumnsFromJson)
    Map<String, Set<Type>> filterableColumns,
    @Default(100) int maxLimit,
    @Default(20) int defaultLimit,
    @JsonKey(fromJson: _defaultSortByFromJson) Map<String, SortOrder>? defaultSortBy,
  }) = _PaginateConfig;

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
