// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PaginatedMetadata _$PaginatedMetadataFromJson(Map<String, dynamic> json) {
  return _PaginatedMetadata.fromJson(json);
}

/// @nodoc
mixin _$PaginatedMetadata {
  /// The maximum amount of items per page.
  int get itemsPerPage => throw _privateConstructorUsedError;

  /// The total amount of items matching the related query before pagination.
  int get totalItems => throw _privateConstructorUsedError;

  /// The page of this request.
  int get currentPage => throw _privateConstructorUsedError;

  /// The total amount of pages matching the related query before pagination.
  int get totalPages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaginatedMetadataCopyWith<PaginatedMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaginatedMetadataCopyWith<$Res> {
  factory $PaginatedMetadataCopyWith(
          PaginatedMetadata value, $Res Function(PaginatedMetadata) then) =
      _$PaginatedMetadataCopyWithImpl<$Res, PaginatedMetadata>;
  @useResult
  $Res call(
      {int itemsPerPage, int totalItems, int currentPage, int totalPages});
}

/// @nodoc
class _$PaginatedMetadataCopyWithImpl<$Res, $Val extends PaginatedMetadata>
    implements $PaginatedMetadataCopyWith<$Res> {
  _$PaginatedMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemsPerPage = null,
    Object? totalItems = null,
    Object? currentPage = null,
    Object? totalPages = null,
  }) {
    return _then(_value.copyWith(
      itemsPerPage: null == itemsPerPage
          ? _value.itemsPerPage
          : itemsPerPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaginatedMetadataImplCopyWith<$Res>
    implements $PaginatedMetadataCopyWith<$Res> {
  factory _$$PaginatedMetadataImplCopyWith(_$PaginatedMetadataImpl value,
          $Res Function(_$PaginatedMetadataImpl) then) =
      __$$PaginatedMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int itemsPerPage, int totalItems, int currentPage, int totalPages});
}

/// @nodoc
class __$$PaginatedMetadataImplCopyWithImpl<$Res>
    extends _$PaginatedMetadataCopyWithImpl<$Res, _$PaginatedMetadataImpl>
    implements _$$PaginatedMetadataImplCopyWith<$Res> {
  __$$PaginatedMetadataImplCopyWithImpl(_$PaginatedMetadataImpl _value,
      $Res Function(_$PaginatedMetadataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? itemsPerPage = null,
    Object? totalItems = null,
    Object? currentPage = null,
    Object? totalPages = null,
  }) {
    return _then(_$PaginatedMetadataImpl(
      itemsPerPage: null == itemsPerPage
          ? _value.itemsPerPage
          : itemsPerPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      currentPage: null == currentPage
          ? _value.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaginatedMetadataImpl implements _PaginatedMetadata {
  const _$PaginatedMetadataImpl(
      {required this.itemsPerPage,
      required this.totalItems,
      required this.currentPage,
      required this.totalPages});

  factory _$PaginatedMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaginatedMetadataImplFromJson(json);

  /// The maximum amount of items per page.
  @override
  final int itemsPerPage;

  /// The total amount of items matching the related query before pagination.
  @override
  final int totalItems;

  /// The page of this request.
  @override
  final int currentPage;

  /// The total amount of pages matching the related query before pagination.
  @override
  final int totalPages;

  @override
  String toString() {
    return 'PaginatedMetadata(itemsPerPage: $itemsPerPage, totalItems: $totalItems, currentPage: $currentPage, totalPages: $totalPages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaginatedMetadataImpl &&
            (identical(other.itemsPerPage, itemsPerPage) ||
                other.itemsPerPage == itemsPerPage) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, itemsPerPage, totalItems, currentPage, totalPages);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaginatedMetadataImplCopyWith<_$PaginatedMetadataImpl> get copyWith =>
      __$$PaginatedMetadataImplCopyWithImpl<_$PaginatedMetadataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaginatedMetadataImplToJson(
      this,
    );
  }
}

abstract class _PaginatedMetadata implements PaginatedMetadata {
  const factory _PaginatedMetadata(
      {required final int itemsPerPage,
      required final int totalItems,
      required final int currentPage,
      required final int totalPages}) = _$PaginatedMetadataImpl;

  factory _PaginatedMetadata.fromJson(Map<String, dynamic> json) =
      _$PaginatedMetadataImpl.fromJson;

  @override

  /// The maximum amount of items per page.
  int get itemsPerPage;
  @override

  /// The total amount of items matching the related query before pagination.
  int get totalItems;
  @override

  /// The page of this request.
  int get currentPage;
  @override

  /// The total amount of pages matching the related query before pagination.
  int get totalPages;
  @override
  @JsonKey(ignore: true)
  _$$PaginatedMetadataImplCopyWith<_$PaginatedMetadataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
