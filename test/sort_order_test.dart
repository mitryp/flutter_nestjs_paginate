import 'package:flutter_nestjs_paginate/flutter_nestjs_paginate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SortOrder tests', () {
    test('SortOrder is deserialized correctly', () {
      expect(SortOrder.fromName('AsC'), equals(SortOrder.asc));
      expect(SortOrder.fromName('dEsC'), equals(SortOrder.desc));
    });

    test('SortOrder.flipped() works correctly', () {
      expect(SortOrder.asc.flipped(), equals(SortOrder.desc));
      expect(SortOrder.desc.flipped(), equals(SortOrder.asc));
    });
  });
}
