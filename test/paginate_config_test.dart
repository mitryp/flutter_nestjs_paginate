import 'package:flutter_nestjs_paginate/flutter_nestjs_paginate.dart';
import 'package:flutter_test/flutter_test.dart';

/// A matching Dart representation of the PaginateConfig from the
/// [`nestjs-paginate` example](https://www.npmjs.com/package/nestjs-paginate#config).
const _nestJsPaginateConfigJson = {
  'sortableColumns': ['id', 'name', 'color'],
  'nullSort': 'last',
  'defaultSortBy': [
    ['name', 'DESC'],
  ],
  'searchableColumns': ['name', 'color'],
  'select': ['id', 'name', 'color'],
  'maxLimit': 20,
  'defaultLimit': 50,
  'where': {'color': 'ginger'},
  'filterableColumns': {
    'age': ['\$eq', '\$in'],
    'name': true,
  },
  'relations': [],
  'loadEagerRelations': true,
  'withDeleted': false,
  'paginationType': 'limit',
  'relativePath': true,
  'origin': 'http://cats.example',
  'ignoreSearchByInQueryParam': true,
  'ignoreSelectInQueryParam': true,
};

const _matchingConfig = PaginateConfig(
  sortableColumns: {'id', 'name', 'color'},
  defaultSortBy: {
    'name': SortOrder.desc,
  },
  defaultLimit: 50,
  maxLimit: 20,
  filterableColumns: {
    'age': {Eq, In},
    'name': {Eq, Not, Null, In, Gt, Lt, Btw, Ilike, Sw, Contains, Or},
  },
);

void main() => group('PaginateConfig tests', () {
      test('PaginateConfig.fromJson works correctly', () {
        final deserialized = PaginateConfig.fromJson(_nestJsPaginateConfigJson);
        expect(deserialized, equals(_matchingConfig));
      });
    });
