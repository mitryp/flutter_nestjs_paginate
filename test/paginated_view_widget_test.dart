import 'package:flutter/material.dart';
import 'package:flutter_nestjs_paginate/flutter_nestjs_paginate.dart';
import 'package:flutter_test/flutter_test.dart';

final _data = List.generate(100, (i) => i);

Future<Paginated<int>> _fetcher(int limit, int page) async {
  final start = limit * (page - 1);
  final end = start + limit;
  final totalPages = (_data.length / limit).ceil();

  return Paginated(
    _data.sublist(start, end),
    PaginatedMetadata(
      totalPages: totalPages,
      totalItems: _data.length,
      currentPage: page,
      itemsPerPage: limit,
    ),
  );
}

Future<Paginated<int>> _delayedFetcher(
  int limit,
  int page, {
  required Duration delay,
}) =>
    Future.delayed(delay, () => _fetcher(limit, page));

Future<Paginated<int>> _errorFetcher() =>
    Future(() => throw StateError('Test error'));

void main() {
  const progressIndicatorKey = ValueKey('progressIndicator');
  final progressIndicatorFinder = find.byKey(progressIndicatorKey);

  const viewKey = ValueKey('view');
  final viewFinder = find.byKey(viewKey);
  final viewItemFinder = find.byWidgetPredicate(
    (widget) => widget is Text && widget.key is ValueKey<int>,
  );

  const errorKey = ValueKey('error');
  final errorFinder = find.byKey(errorKey);

  final controller = PaginationController(validateColumns: false);

  testWidgets(
    'A PaginatedView calls the loading indicator builder while the fetcher is loading, '
    'and the viewBuilder when the data is loaded',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            child: PaginatedView(
              controller: controller,
              viewBuilder: (context, data) => Column(
                key: viewKey,
                children: [
                  ...data.data.map((e) => Text('$e', key: ValueKey(e))),
                ],
              ),
              loadingIndicator: (context) =>
                  const CircularProgressIndicator(key: progressIndicatorKey),
              errorBuilder: (context, error) => Text('$error', key: errorKey),
              fetcher: (context, params) => _delayedFetcher(
                params['limit'] as int,
                params['page'] as int,
                delay: const Duration(milliseconds: 50),
              ),
            ),
          ),
        ),
      );

      expect(progressIndicatorFinder, findsOneWidget);

      await widgetTester.pump(const Duration(milliseconds: 60));

      expect(progressIndicatorFinder, findsNothing);
      expect(viewFinder, findsOneWidget);
      expect(viewItemFinder, findsNWidgets(controller.limit));
    },
  );

  testWidgets(
    'A PaginatedView calls the error builder when the error occurs',
    (widgetTester) async {
      await widgetTester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Material(
            child: PaginatedView(
              controller: controller,
              viewBuilder: (context, data) => Column(
                key: viewKey,
                children: [
                  ...data.data.map((e) => Text('$e', key: ValueKey(e))),
                ],
              ),
              loadingIndicator: (context) =>
                  const CircularProgressIndicator(key: progressIndicatorKey),
              errorBuilder: (context, error) => Text('$error', key: errorKey),
              fetcher: (context, params) => _errorFetcher(),
            ),
          ),
        ),
      );

      await widgetTester.pump(const Duration());

      expect(errorFinder, findsOneWidget);
    },
  );
}
