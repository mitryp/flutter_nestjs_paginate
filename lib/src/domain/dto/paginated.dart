import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'paginated.freezed.dart';

part 'paginated.g.dart';

/// A DTO matching the result of `paginate` function from `nestjs-paginate`.
///
/// It has the List<[TDto]> [data] and [PaginatedMetadata] - [meta].
///
/// The factory [fromJson] parses the [JsonMap] received from the server using the provided decoder.
///
/// See also:
/// - [PaginatedMetadata]
/// - [Paginated.fromJson]
class Paginated<TDto> {
  /// A list of [TDto].
  final List<TDto> data;

  /// A [PaginatedMetadata] describing the [data].
  final PaginatedMetadata meta;

  /// Creates a Paginated<[TDto]> with the given parameters.
  const Paginated(this.data, this.meta);

  /// Parses the given [json] to extract the list of [data] and the [PaginatedMetadata] describing
  /// it.
  ///
  /// Uses the given [decoder] to build [TDto] instances from each [JsonMap] inside the `data` list.
  ///
  /// Supports the default `nestjs-paginate` JSON structure:
  /// ```dart
  /// {
  ///   'data': List<Map>,
  ///   'meta': Map,
  /// }
  /// ```
  ///
  /// If your API returns paginated data in another way, you will need to create the Paginated
  /// instance yourself.
  static Paginated<TDto> fromJson<TDto>(
    JsonMap json,
    FromJsonDecoder<TDto> decoder,
  ) {
    final data = json['data'] as List<dynamic>;
    final meta = json['meta'] as Map<String, dynamic>;

    return Paginated(
      data.cast<Map<String, dynamic>>().map(decoder).toList(growable: false),
      PaginatedMetadata.fromJson(meta),
    );
  }
}

/// A metadata describing the pagination.
///
/// Currently, features only the fields directly connected to paging.
@freezed
class PaginatedMetadata with _$PaginatedMetadata {
  /// Creates a [PaginatedMetadata] with the given parameters.
  const factory PaginatedMetadata({
    /// The maximum amount of items per page.
    required int itemsPerPage,

    /// The total amount of items matching the related query before pagination.
    required int totalItems,

    /// The page of this request.
    required int currentPage,

    /// The total amount of pages matching the related query before pagination.
    required int totalPages,
  }) = _PaginatedMetadata;

  /// Parses a [PaginatedMetadata] from the given [json].
  factory PaginatedMetadata.fromJson(Map<String, Object?> json) =>
      _$PaginatedMetadataFromJson(json);
}
