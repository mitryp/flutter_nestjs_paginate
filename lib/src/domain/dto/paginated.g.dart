// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaginatedMetadataImpl _$$PaginatedMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$PaginatedMetadataImpl(
      itemsPerPage: json['itemsPerPage'] as int,
      totalItems: json['totalItems'] as int,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
    );

Map<String, dynamic> _$$PaginatedMetadataImplToJson(
        _$PaginatedMetadataImpl instance) =>
    <String, dynamic>{
      'itemsPerPage': instance.itemsPerPage,
      'totalItems': instance.totalItems,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
    };
