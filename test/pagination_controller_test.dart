import 'package:flutter_nestjs_paginate/flutter_nestjs_paginate.dart';
import 'package:flutter_nestjs_paginate/src/application/pagination_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaginationController initialization tests', () {
    test(
      'PaginationController is initialized correctly with a default PaginateConfig',
      () {
        final controller = PaginationController();

        expect(controller.page, equals(1));
        expect(controller.limit, equals(20));
        expect(controller.filters, isEmpty);
        expect(controller.sorts, isEmpty);
        expect(controller.search, isNull);
      },
    );

    test(
      'PaginationController is initialized correctly with the given values',
      () {
        const testLimit = 1;
        const testPage = 2;
        final testFilters = {
          'name': {
            const In(['a', 'b']),
          },
        };
        const testSorts = {
          'name': SortOrder.desc,
        };
        const testSearch = 'search';
        const testConfig = PaginateConfig(maxLimit: 2000);

        final controller = PaginationController(
          limit: testLimit,
          page: testPage,
          filters: testFilters,
          sorts: testSorts,
          search: testSearch,
          paginateConfig: testConfig,
        );

        expect(controller.limit, equals(testLimit));
        expect(controller.page, equals(testPage));
        expect(controller.filters, equals(testFilters));
        expect(controller.sorts, equals(testSorts));
        expect(controller.search, equals(testSearch));
        expect(controller.paginateConfig, equals(testConfig));
      },
    );
  });

  group('PaginationController strict validation tests', () {
    const sortableColumn = 'sortable';
    const filterableColumn = 'filterable';

    final controller = PaginationController(
      strictValidation: true,
      paginateConfig: const PaginateConfig(
        sortableColumns: {
          sortableColumn,
        },
        filterableColumns: {
          filterableColumn: {Eq},
        },
      ),
    );

    setUp(
      () => controller
        ..clearFilters()
        ..clearSorts(),
    );

    test(
      'Strict Controller throws when adding a sort by a not allowed field',
      () => expect(
        () => controller.addSort('${sortableColumn}a', SortOrder.asc),
        throwsStateError,
      ),
    );

    test(
      'Strict Controller throws when adding a filter '
      'by a not allowed field and an allowed operator',
      () => expect(
        () => controller.addFilter('${filterableColumn}a', const Eq(1)),
        throwsStateError,
      ),
    );

    test(
      'Strict Controller throws when adding a filter '
      'by an allowed field and a not allowed operator',
      () => expect(
        () => controller.addFilter(filterableColumn, const Lt(1)),
        throwsStateError,
      ),
    );

    test(
      'Strict Controller does not throw when adding allowed sorts and filters',
      () {
        expect(
          () => controller
            ..addSort(sortableColumn, SortOrder.asc)
            ..addFilter(filterableColumn, const Eq(1)),
          returnsNormally,
        );
      },
    );
  });

  group('PaginationController non-strict validation tests', () {
    const sortableColumn = 'sortable';
    const filterableColumn = 'filterable';

    final controller = PaginationController(
      paginateConfig: const PaginateConfig(
        sortableColumns: {
          sortableColumn,
        },
        filterableColumns: {
          filterableColumn: {Eq},
        },
      ),
    );

    setUp(
      () => controller
        ..clearFilters()
        ..clearSorts(),
    );

    test(
      'Non-strict Controller does nothing when adding a sort by a not allowed field',
      () {
        expect(() => controller.addSort('${sortableColumn}a', SortOrder.asc), returnsNormally);
        expect(controller.sorts, isEmpty);
      },
    );

    test(
      'Non-strict Controller does nothing when adding a filter '
      'by a not allowed field and an allowed operator',
      () {
        expect(() => controller.addFilter(sortableColumn, const Eq(1)), returnsNormally);
        expect(controller.filters, isEmpty);
      },
    );

    test(
      'Non-strict Controller does nothing when adding a filter '
      'by an allowed field and a not allowed operator',
      () {
        expect(() => controller.addFilter(sortableColumn, const Lt(1)), returnsNormally);
        expect(controller.filters, isEmpty);
      },
    );

    test(
      'Non-strict Controller adds when adding allowed sorts and filters',
      () {
        expect(
          () => controller
            ..addSort(sortableColumn, SortOrder.asc)
            ..addFilter(filterableColumn, const Eq(1)),
          returnsNormally,
        );
      },
    );
  });

  group('PaginationController disabled validation tests', () {
    const sortableColumn = 'sortable';
    const filterableColumn = 'filterable';
    const allowedFilter = Eq(1);

    final controller = PaginationController(
      validateColumns: false,
      paginateConfig: const PaginateConfig(
        sortableColumns: {
          sortableColumn,
        },
        filterableColumns: {
          filterableColumn: {Eq},
        },
      ),
    );

    setUp(
      () => controller
        ..clearFilters()
        ..clearSorts(),
    );

    const sortOrder = SortOrder.asc;

    test(
      'Controller with a disabled validation allows adding a sort by a not allowed field',
      () {
        const col = '${sortableColumn}a';

        expect(() => controller.addSort(col, sortOrder), returnsNormally);
        expect(controller.sorts, allOf(hasLength(1), equals({col: sortOrder})));
      },
    );

    test(
      'Controller with a disabled validation allows adding a filter '
      'by a not allowed field and an allowed operator',
      () {
        const col = '${filterableColumn}a';

        expect(() => controller.addFilter(col, allowedFilter), returnsNormally);
        expect(
          controller.filters,
          allOf(
            hasLength(1),
            equals({
              col: {allowedFilter},
            }),
          ),
        );
      },
    );

    test(
      'Controller with a disabled validation allows adding a filter '
      'by an allowed field and a not allowed operator',
      () {
        const op = Lt(1);

        expect(() => controller.addFilter(filterableColumn, op), returnsNormally);
        expect(
          controller.filters,
          allOf(
            hasLength(1),
            equals({
              filterableColumn: {op},
            }),
          ),
        );
      },
    );

    test(
      'Controller with a disabled validation allows adding allowed sorts and filters',
      () {
        expect(
          () => controller
            ..addSort(sortableColumn, SortOrder.asc)
            ..addFilter(filterableColumn, allowedFilter),
          returnsNormally,
        );
      },
    );
  });

  group(
    'PaginationController notification and changes tests',
    () {
      const testFilterName1 = 'name';
      const testFilterName2 = 'age';
      const testSortName1 = testFilterName1;
      const testSortName2 = testFilterName2;

      final controller = _ExposedController(
        paginateConfig: const PaginateConfig(
          filterableColumns: {
            testFilterName1: {Eq, Ilike},
            testFilterName2: {Eq, Lt, Gt},
          },
          sortableColumns: {
            testSortName1,
            testSortName2,
          },
        ),
      );

      setUp(controller.resetNotificationCounter);

      test('Page changes and notifies correctly', () {
        controller.page++;
        expect(controller.notificationCount, equals(1));

        controller.resetNotificationCounter();

        controller.page = controller.page;
        expect(controller.didNotify, isFalse);
      });

      test('Limit changes and notifies correctly', () {
        controller.limit++;
        expect(controller.notificationCount, equals(1));

        controller.resetNotificationCounter();

        controller.limit = controller.limit;
        expect(controller.didNotify, isFalse);

        // the limit should be set to the maxLimit if the value exceeds it
        controller.limit = controller.paginateConfig.maxLimit + 10;
        expect(controller.notificationCount, equals(1));
        expect(controller.limit, equals(controller.paginateConfig.maxLimit));
      });

      test('Search changes and notifies correctly', () {
        const testSearchQuery = 'search';

        controller.search = testSearchQuery;
        expect(controller.notificationCount, equals(1));
        expect(controller.search, equals(testSearchQuery));

        controller.resetNotificationCounter();

        controller.search = testSearchQuery;
        expect(controller.didNotify, isFalse);

        controller.search = null;
        expect(controller.notificationCount, equals(1));
      });

      const testFilterOperator = Eq('abc');

      test('Filters are added and notify correctly', () {
        controller.addFilter(testFilterName1, testFilterOperator);
        expect(controller.notificationCount, equals(1));
        expect(controller.filters, hasLength(1));
        expect(controller.filters[testFilterName1], equals({testFilterOperator}));

        controller.resetNotificationCounter();

        // adding the same filter twice should not notify
        controller.addFilter(testFilterName1, testFilterOperator);
        expect(controller.didNotify, isFalse);

        const testFilterOperator2 = Lt(18, orEqual: true);
        controller.addFilter(testFilterName2, testFilterOperator2);
        expect(controller.notificationCount, equals(1));
        expect(controller.filters, hasLength(2));
        expect(controller.filters[testFilterName2], equals({testFilterOperator2}));

        controller.removeFilter(testFilterName2);
      });

      test('Filters are removed and notify correctly', () {
        final otherOperator = Eq('${testFilterOperator.value}a');

        // removing non-existent filter should not notify
        controller.removeFilter(testFilterName1, otherOperator);
        expect(controller.didNotify, isFalse);
        expect(controller.filters, hasLength(1));

        // removing existent filter should notify once
        controller.removeFilter(testFilterName1, testFilterOperator);
        expect(controller.notificationCount, equals(1));
        expect(controller.filters[testFilterName1], isEmpty);

        controller.resetNotificationCounter();

        // removing the same filter for the second time should not notify
        controller.removeFilter(testFilterName1, testFilterOperator);
        expect(controller.didNotify, isFalse);

        // removing all filters by a field name should notify once
        controller
          ..addFilter(testFilterName1, testFilterOperator)
          ..addFilter(testFilterName1, otherOperator);

        expect(controller.notificationCount, equals(2));

        controller
          ..resetNotificationCounter()
          ..removeFilter(testFilterName1);
        expect(controller.notificationCount, equals(1));
        expect(controller.filters, isEmpty);
      });

      test('Filters are cleared correctly with', () {
        controller
          ..addFilter(testFilterName1, testFilterOperator)
          ..addFilter(testFilterName1, const Ilike('abc'))
          ..resetNotificationCounter();

        controller.clearFilters();
        expect(controller.notificationCount, equals(1));
        expect(controller.filters, isEmpty);
      });

      const testSort = SortOrder.asc;

      test('Sorts are added and notify correctly', () {
        // adding a new sort should notify
        controller.addSort(testSortName1, testSort);
        expect(controller.notificationCount, equals(1));
        expect(controller.sorts, hasLength(1));
        expect(controller.sorts[testSortName1], equals(testSort));

        // adding the same sort should not notify
        controller
          ..resetNotificationCounter()
          ..addSort(testSortName1, testSort);
        expect(controller.didNotify, isFalse);
        expect(controller.sorts, hasLength(1));

        // adding a different sort by the same name should notify
        // and override the existing value
        controller.addSort(testSortName1, testSort.flipped());
        expect(controller.notificationCount, equals(1));
        expect(controller.sorts, hasLength(1));
        expect(controller.sorts[testSortName1], equals(testSort.flipped()));

        controller.addSort(testSortName2, testSort);
        expect(controller.notificationCount, equals(2));
        expect(controller.sorts, hasLength(2));
        expect(controller.sorts[testSortName1], equals(testSort.flipped()));
        expect(controller.sorts[testSortName2], equals(testSort));
      });

      test('Sorts are removed and notify correctly', () {
        // removing a non-existent sort should not notify
        controller.removeSort('${testSortName1}a');
        expect(controller.didNotify, isFalse);
        expect(controller.sorts, hasLength(2));
        expect(controller.sorts[testSortName1], equals(testSort.flipped()));

        // removing an existent sort should notify
        controller.removeSort(testSortName1);
        expect(controller.notificationCount, equals(1));
        expect(controller.sorts, hasLength(1));
      });

      test('Sorts are cleared correctly with empty defaultSortBy', () {
        controller
          ..addSort(testSortName2, testSort)
          ..resetNotificationCounter();

        controller.clearSorts();
        expect(controller.notificationCount, equals(1));
        expect(controller.sorts, isEmpty);
      });

      test('silently works correctly', () {
        // without silently controller should notify 4 times here
        controller
          ..page = controller.page + 1
          ..limit = controller.limit + 10
          ..addSort(testSortName1, testSort)
          ..addFilter(testFilterName1, testFilterOperator);
        expect(controller.notificationCount, equals(4));

        controller.resetNotificationCounter();

        controller.silently(
          (controller) => controller
            ..page = controller.page + 1
            ..limit = controller.limit + 10
            ..addSort(testSortName2, testSort)
            ..addFilter(testFilterName2, testFilterOperator),
        );
        expect(controller.didNotify, isFalse);

        controller.silently(
          notifyAfter: true,
          (controller) => controller
            ..page = controller.page + 1
            ..limit = controller.limit + 10
            ..clearSorts()
            ..clearFilters(),
        );
        expect(controller.notificationCount, equals(1));
      });
    },
  );

  group('PaginationController.toMap tests', () {
    const filterableColumn1 = 'age';
    const filterableColumn2 = 'name';
    const sortableColumn1 = filterableColumn1;
    const sortableColumn2 = filterableColumn2;
    const sort1 = SortOrder.asc;
    const sort2 = SortOrder.desc;
    const filter1 = Eq(10);
    const filter2 = Btw(1, 20);

    const page = 10;
    const limit = 70;
    final search = 'a' * 10;

    final controller = PaginationController(validateColumns: false);

    controller
      ..page = page
      ..limit = limit
      ..search = search
      ..addSort(sortableColumn1, sort1)
      ..addSort(sortableColumn2, sort2)
      ..addFilter(filterableColumn1, filter1)
      ..addFilter(filterableColumn1, filter2)
      ..addFilter(filterableColumn2, filter2);

    final map = controller.toMap();

    test('Map is generated correctly', () {
      expect(map, hasLength(6));
      expect(map['page'], equals(page));
      expect(map['limit'], equals(limit));
      expect(map['search'], equals(search));
      expect(
        map['filter.$filterableColumn1'],
        allOf(
          isA<List<String>>(),
          hasLength(2),
          containsAll([filter1, filter2].map((e) => e.toString())),
        ),
      );
      expect(
        map['filter.$filterableColumn2'],
        allOf(
          isA<List<String>>(),
          hasLength(1),
          containsAll([filter2].map((e) => e.toString())),
        ),
      );
      expect(
        map['sortBy'],
        allOf(
          isA<List<String>>(),
          hasLength(2),
          containsAll([
            '$sortableColumn1:${sort1.name.toUpperCase()}',
            '$sortableColumn2:${sort2.name.toUpperCase()}',
          ]),
        ),
      );
    });
  });
}

class _ExposedController extends PaginationControllerImpl {
  int notificationCount = 0;

  bool get didNotify => notificationCount > 0;

  _ExposedController({super.paginateConfig = const PaginateConfig()})
      : super(strictValidation: true);

  @override
  void notifyListeners() {
    super.notifyListeners();
    if (doesNotify) notificationCount++;
  }

  void resetNotificationCounter() => notificationCount = 0;
}
