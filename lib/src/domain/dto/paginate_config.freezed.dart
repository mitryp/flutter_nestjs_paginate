// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginate_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PaginateConfig _$PaginateConfigFromJson(Map<String, dynamic> json) {
  return _PaginateConfig.fromJson(json);
}

/// @nodoc
mixin _$PaginateConfig {
  /// A set of columns allowed to be used in sorts.
  ///
  /// If strict validation is enabled, adding a sort with the column not in the set will cause
  /// StateError. Otherwise, the sort will be ignored unless validation is disabled.
  @JsonKey(fromJson: _sortableColumnsFromJson)
  Set<String> get sortableColumns => throw _privateConstructorUsedError;

  /// A set of columns allowed for filtering by.
  ///
  /// If strict validation is enabled, adding a filter with the column not in the set will cause
  /// StateError. Otherwise, the filter will be ignored unless validation is disabled.
  @JsonKey(fromJson: _filterableColumnsFromJson)
  Map<String, Set<Type>> get filterableColumns =>
      throw _privateConstructorUsedError;

  /// A maximum limit accepted by the server.
  /// A controller will not increase its limit over this value.
  int get maxLimit => throw _privateConstructorUsedError;

  /// A limit to be set by default.
  int get defaultLimit => throw _privateConstructorUsedError;

  /// The default sorts applied when no sorts are configured in a controller.
  @JsonKey(fromJson: _defaultSortByFromJson)
  Map<String, SortOrder> get defaultSortBy =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PaginateConfigCopyWith<PaginateConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginateConfigCopyWith<$Res> {
  factory $PaginateConfigCopyWith(
          PaginateConfig value, $Res Function(PaginateConfig) then) =
      _$PaginateConfigCopyWithImpl<$Res, PaginateConfig>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _sortableColumnsFromJson) Set<String> sortableColumns,
      @JsonKey(fromJson: _filterableColumnsFromJson)
      Map<String, Set<Type>> filterableColumns,
      int maxLimit,
      int defaultLimit,
      @JsonKey(fromJson: _defaultSortByFromJson)
      Map<String, SortOrder> defaultSortBy});
}

/// @nodoc
class _$PaginateConfigCopyWithImpl<$Res, $Val extends PaginateConfig>
    implements $PaginateConfigCopyWith<$Res> {
  _$PaginateConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortableColumns = null,
    Object? filterableColumns = null,
    Object? maxLimit = null,
    Object? defaultLimit = null,
    Object? defaultSortBy = null,
  }) {
    return _then(_value.copyWith(
      sortableColumns: null == sortableColumns
          ? _value.sortableColumns
          : sortableColumns // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      filterableColumns: null == filterableColumns
          ? _value.filterableColumns
          : filterableColumns // ignore: cast_nullable_to_non_nullable
              as Map<String, Set<Type>>,
      maxLimit: null == maxLimit
          ? _value.maxLimit
          : maxLimit // ignore: cast_nullable_to_non_nullable
              as int,
      defaultLimit: null == defaultLimit
          ? _value.defaultLimit
          : defaultLimit // ignore: cast_nullable_to_non_nullable
              as int,
      defaultSortBy: null == defaultSortBy
          ? _value.defaultSortBy
          : defaultSortBy // ignore: cast_nullable_to_non_nullable
              as Map<String, SortOrder>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginateConfigImplCopyWith<$Res>
    implements $PaginateConfigCopyWith<$Res> {
  factory _$$PaginateConfigImplCopyWith(_$PaginateConfigImpl value,
          $Res Function(_$PaginateConfigImpl) then) =
      __$$PaginateConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _sortableColumnsFromJson) Set<String> sortableColumns,
      @JsonKey(fromJson: _filterableColumnsFromJson)
      Map<String, Set<Type>> filterableColumns,
      int maxLimit,
      int defaultLimit,
      @JsonKey(fromJson: _defaultSortByFromJson)
      Map<String, SortOrder> defaultSortBy});
}

/// @nodoc
class __$$PaginateConfigImplCopyWithImpl<$Res>
    extends _$PaginateConfigCopyWithImpl<$Res, _$PaginateConfigImpl>
    implements _$$PaginateConfigImplCopyWith<$Res> {
  __$$PaginateConfigImplCopyWithImpl(
      _$PaginateConfigImpl _value, $Res Function(_$PaginateConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sortableColumns = null,
    Object? filterableColumns = null,
    Object? maxLimit = null,
    Object? defaultLimit = null,
    Object? defaultSortBy = null,
  }) {
    return _then(_$PaginateConfigImpl(
      sortableColumns: null == sortableColumns
          ? _value._sortableColumns
          : sortableColumns // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      filterableColumns: null == filterableColumns
          ? _value._filterableColumns
          : filterableColumns // ignore: cast_nullable_to_non_nullable
              as Map<String, Set<Type>>,
      maxLimit: null == maxLimit
          ? _value.maxLimit
          : maxLimit // ignore: cast_nullable_to_non_nullable
              as int,
      defaultLimit: null == defaultLimit
          ? _value.defaultLimit
          : defaultLimit // ignore: cast_nullable_to_non_nullable
              as int,
      defaultSortBy: null == defaultSortBy
          ? _value._defaultSortBy
          : defaultSortBy // ignore: cast_nullable_to_non_nullable
              as Map<String, SortOrder>,
    ));
  }
}

/// @nodoc
@JsonSerializable(createToJson: false)
class _$PaginateConfigImpl implements _PaginateConfig {
  const _$PaginateConfigImpl(
      {@JsonKey(fromJson: _sortableColumnsFromJson)
      final Set<String> sortableColumns = const {},
      @JsonKey(fromJson: _filterableColumnsFromJson)
      final Map<String, Set<Type>> filterableColumns = const {},
      this.maxLimit = _defaultMaxLimit,
      this.defaultLimit = _defaultDefaultLimit,
      @JsonKey(fromJson: _defaultSortByFromJson)
      final Map<String, SortOrder> defaultSortBy = const {}})
      : _sortableColumns = sortableColumns,
        _filterableColumns = filterableColumns,
        _defaultSortBy = defaultSortBy;

  factory _$PaginateConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginateConfigImplFromJson(json);

  /// A set of columns allowed to be used in sorts.
  ///
  /// If strict validation is enabled, adding a sort with the column not in the set will cause
  /// StateError. Otherwise, the sort will be ignored unless validation is disabled.
  final Set<String> _sortableColumns;

  /// A set of columns allowed to be used in sorts.
  ///
  /// If strict validation is enabled, adding a sort with the column not in the set will cause
  /// StateError. Otherwise, the sort will be ignored unless validation is disabled.
  @override
  @JsonKey(fromJson: _sortableColumnsFromJson)
  Set<String> get sortableColumns {
    if (_sortableColumns is EqualUnmodifiableSetView) return _sortableColumns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_sortableColumns);
  }

  /// A set of columns allowed for filtering by.
  ///
  /// If strict validation is enabled, adding a filter with the column not in the set will cause
  /// StateError. Otherwise, the filter will be ignored unless validation is disabled.
  final Map<String, Set<Type>> _filterableColumns;

  /// A set of columns allowed for filtering by.
  ///
  /// If strict validation is enabled, adding a filter with the column not in the set will cause
  /// StateError. Otherwise, the filter will be ignored unless validation is disabled.
  @override
  @JsonKey(fromJson: _filterableColumnsFromJson)
  Map<String, Set<Type>> get filterableColumns {
    if (_filterableColumns is EqualUnmodifiableMapView)
      return _filterableColumns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_filterableColumns);
  }

  /// A maximum limit accepted by the server.
  /// A controller will not increase its limit over this value.
  @override
  @JsonKey()
  final int maxLimit;

  /// A limit to be set by default.
  @override
  @JsonKey()
  final int defaultLimit;

  /// The default sorts applied when no sorts are configured in a controller.
  final Map<String, SortOrder> _defaultSortBy;

  /// The default sorts applied when no sorts are configured in a controller.
  @override
  @JsonKey(fromJson: _defaultSortByFromJson)
  Map<String, SortOrder> get defaultSortBy {
    if (_defaultSortBy is EqualUnmodifiableMapView) return _defaultSortBy;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_defaultSortBy);
  }

  @override
  String toString() {
    return 'PaginateConfig(sortableColumns: $sortableColumns, filterableColumns: $filterableColumns, maxLimit: $maxLimit, defaultLimit: $defaultLimit, defaultSortBy: $defaultSortBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginateConfigImpl &&
            const DeepCollectionEquality()
                .equals(other._sortableColumns, _sortableColumns) &&
            const DeepCollectionEquality()
                .equals(other._filterableColumns, _filterableColumns) &&
            (identical(other.maxLimit, maxLimit) ||
                other.maxLimit == maxLimit) &&
            (identical(other.defaultLimit, defaultLimit) ||
                other.defaultLimit == defaultLimit) &&
            const DeepCollectionEquality()
                .equals(other._defaultSortBy, _defaultSortBy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_sortableColumns),
      const DeepCollectionEquality().hash(_filterableColumns),
      maxLimit,
      defaultLimit,
      const DeepCollectionEquality().hash(_defaultSortBy));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginateConfigImplCopyWith<_$PaginateConfigImpl> get copyWith =>
      __$$PaginateConfigImplCopyWithImpl<_$PaginateConfigImpl>(
          this, _$identity);
}

abstract class _PaginateConfig implements PaginateConfig {
  const factory _PaginateConfig(
      {@JsonKey(fromJson: _sortableColumnsFromJson)
      final Set<String> sortableColumns,
      @JsonKey(fromJson: _filterableColumnsFromJson)
      final Map<String, Set<Type>> filterableColumns,
      final int maxLimit,
      final int defaultLimit,
      @JsonKey(fromJson: _defaultSortByFromJson)
      final Map<String, SortOrder> defaultSortBy}) = _$PaginateConfigImpl;

  factory _PaginateConfig.fromJson(Map<String, dynamic> json) =
      _$PaginateConfigImpl.fromJson;

  @override

  /// A set of columns allowed to be used in sorts.
  ///
  /// If strict validation is enabled, adding a sort with the column not in the set will cause
  /// StateError. Otherwise, the sort will be ignored unless validation is disabled.
  @JsonKey(fromJson: _sortableColumnsFromJson)
  Set<String> get sortableColumns;
  @override

  /// A set of columns allowed for filtering by.
  ///
  /// If strict validation is enabled, adding a filter with the column not in the set will cause
  /// StateError. Otherwise, the filter will be ignored unless validation is disabled.
  @JsonKey(fromJson: _filterableColumnsFromJson)
  Map<String, Set<Type>> get filterableColumns;
  @override

  /// A maximum limit accepted by the server.
  /// A controller will not increase its limit over this value.
  int get maxLimit;
  @override

  /// A limit to be set by default.
  int get defaultLimit;
  @override

  /// The default sorts applied when no sorts are configured in a controller.
  @JsonKey(fromJson: _defaultSortByFromJson)
  Map<String, SortOrder> get defaultSortBy;
  @override
  @JsonKey(ignore: true)
  _$$PaginateConfigImplCopyWith<_$PaginateConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
