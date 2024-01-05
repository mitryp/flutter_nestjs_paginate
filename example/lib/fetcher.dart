import 'package:flutter_nestjs_paginate/flutter_nestjs_paginate.dart';
import 'package:flutter_nestjs_paginate_example/dto.dart';

const _data = [];

Paginated<CityDto> fetch() {
  return Paginated(
    [],
    PaginatedMetadata(),
  );
}
