import 'dart:math';

import 'package:flutter_nestjs_paginate/flutter_nestjs_paginate.dart';
import 'package:flutter_nestjs_paginate_example/dto.dart';

const _data = <CityDto>[
  CityDto(id: 1, name: 'Kyiv', population: 2797553),
  CityDto(id: 2, name: 'Kharkiv', population: 1430885),
  CityDto(id: 3, name: 'Dnipro', population: 1032822),
  CityDto(id: 4, name: 'Donetsk', population: 1024700),
  CityDto(id: 5, name: 'Odessa', population: 1001558),
  CityDto(id: 6, name: 'Zaporizhia', population: 796217),
  CityDto(id: 7, name: 'Lviv', population: 717803),
  CityDto(id: 8, name: 'Kryvyi Rih', population: 652380),
  CityDto(id: 9, name: 'Mykolayiv', population: 510840),
  CityDto(id: 10, name: 'Mariupol', population: 481626),
  CityDto(id: 11, name: 'Luhansk', population: 452000),
  CityDto(id: 12, name: 'Sevastopol', population: 416263),
  CityDto(id: 13, name: 'Khmelnytskyi', population: 398346),
  CityDto(id: 14, name: 'Makiyivka', population: 376610),
  CityDto(id: 15, name: 'Vinnytsia', population: 352115),
  CityDto(id: 16, name: 'Simferopol', population: 336460),
  CityDto(id: 17, name: 'Kherson', population: 320477),
  CityDto(id: 18, name: 'Poltava', population: 317847),
  CityDto(id: 19, name: 'Chernihiv', population: 307684),
  CityDto(id: 20, name: 'Cherkasy', population: 297568),
];

const _fetchDelay = Duration(milliseconds: 500);

// a simple local fetcher supporting basic pagination
// despite the example does not use nestjs-paginate, the library is tested on a fully
// functional nestjs-paginate mock
Future<Paginated<CityDto>> fetch({
  int limit = 5,
  int page = 1,
}) {
  page = max(1, page);
  limit = max(1, limit);

  final startOffset = (page - 1) * limit;
  final endOffset = min(startOffset + limit, _data.length);

  return Future.delayed(
    _fetchDelay,
    () => Paginated(
      _data.sublist(startOffset, endOffset),
      PaginatedMetadata(
        itemsPerPage: limit,
        currentPage: page,
        totalItems: _data.length,
        totalPages: max(1, (_data.length / limit).ceil()),
      ),
    ),
  );
}
