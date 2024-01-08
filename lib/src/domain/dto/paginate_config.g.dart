// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginate_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginateConfigImpl _$$PaginateConfigImplFromJson(Map<String, dynamic> json) =>
    _$PaginateConfigImpl(
      sortableColumns: json['sortableColumns'] == null
          ? const {}
          : _sortableColumnsFromJson(json['sortableColumns'] as List),
      filterableColumns: json['filterableColumns'] == null
          ? const {}
          : _filterableColumnsFromJson(
              json['filterableColumns'] as Map<String, dynamic>),
      maxLimit: json['maxLimit'] as int? ?? _defaultMaxLimit,
      defaultLimit: json['defaultLimit'] as int? ?? _defaultDefaultLimit,
      defaultSortBy: json['defaultSortBy'] == null
          ? const {}
          : _defaultSortByFromJson(json['defaultSortBy'] as List),
    );
