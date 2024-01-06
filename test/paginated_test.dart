import 'dart:math';

import 'package:flutter_nestjs_paginate/flutter_nestjs_paginate.dart';
import 'package:flutter_test/flutter_test.dart';

import 'city_dto.dart';

final _data = [
  const CityDto(id: 1, name: 'Kyiv', population: 2797553),
  const CityDto(id: 2, name: 'Kharkiv', population: 1430885),
  const CityDto(id: 3, name: 'Dnipro', population: 1032822),
  const CityDto(id: 4, name: 'Donetsk', population: 1024700),
  const CityDto(id: 5, name: 'Odessa', population: 1001558),
  const CityDto(id: 6, name: 'Zaporizhia', population: 796217),
  const CityDto(id: 7, name: 'Lviv', population: 717803),
  const CityDto(id: 8, name: 'Kryvyi Rih', population: 652380),
  const CityDto(id: 9, name: 'Mykolayiv', population: 510840),
  const CityDto(id: 10, name: 'Mariupol', population: 481626),
  const CityDto(id: 11, name: 'Luhansk', population: 452000),
  const CityDto(id: 12, name: 'Sevastopol', population: 416263),
  const CityDto(id: 13, name: 'Khmelnytskyi', population: 398346),
  const CityDto(id: 14, name: 'Makiyivka', population: 376610),
  const CityDto(id: 15, name: 'Vinnytsia', population: 352115),
  const CityDto(id: 16, name: 'Simferopol', population: 336460),
  const CityDto(id: 17, name: 'Kherson', population: 320477),
  const CityDto(id: 18, name: 'Poltava', population: 317847),
  const CityDto(id: 19, name: 'Chernihiv', population: 307684),
  const CityDto(id: 20, name: 'Cherkasy', population: 297568),
]..shuffle();

final _paginatedJson = {
  'data': _data.map((e) => e.toJson()).toList(growable: false),
  'meta': {
    'itemsPerPage': 5,
    'totalItems': _data.length,
    'currentPage': 1,
    'totalPages': max(1, (_data.length / 5).ceil()),
  },
};

final _metaMatcher = PaginatedMetadata(
  itemsPerPage: (_paginatedJson['meta'] as Map)['itemsPerPage'] as int,
  totalItems: (_paginatedJson['meta'] as Map)['totalItems'] as int,
  currentPage: (_paginatedJson['meta'] as Map)['currentPage'] as int,
  totalPages: (_paginatedJson['meta'] as Map)['totalPages'] as int,
);

void main() => group('Paginated DTO tests', () {
      test('Paginated<CityDto> is deserialized correctly', () {
        final deserialized = Paginated.fromJson(_paginatedJson, CityDto.fromJson);

        expect(deserialized.data, equals(_data));
        expect(deserialized.meta, equals(_metaMatcher));
      });
    });
