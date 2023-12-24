import 'package:freezed_annotation/freezed_annotation.dart';

import '../typedefs.dart';

part 'paginated.freezed.dart';

part 'paginated.g.dart';

class Paginated<TDto> {
  final List<TDto> data;
  final PaginatedMetadata meta;

  const Paginated(this.data, this.meta);

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

@freezed
class PaginatedMetadata with _$PaginatedMetadata {
  const factory PaginatedMetadata({
    required int itemsPerPage,
    required int totalItems,
    required int currentPage,
    required int totalPages,
  }) = _PaginatedMetadata;

  factory PaginatedMetadata.fromJson(Map<String, Object?> json) =>
      _$PaginatedMetadataFromJson(json);
}
