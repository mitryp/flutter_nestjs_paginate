import 'dart:math';

import 'package:flutter_nestjs_paginate/flutter_nestjs_paginate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_utils/test_utils.dart';

const testRuns = 100;
const maxInt = 2 << 10;

final rand = Random();

int rInt() => rand.nextInt(maxInt) - rand.nextInt(maxInt);

void main() {
  group('FilterOperator representation is correct', () {
    // $eq
    test(
      '\$eq is represented correctly',
      () => repeat(
        times: testRuns,
        () => _testOperator(Eq.new, (arg) => '\$eq:$arg'),
      ),
    );

    // $null
    test(
      '\$null is represented correctly',
      () => repeat(
        times: testRuns,
        () => _testOperator((_) => const Null(), (_) => '\$null'),
      ),
    );

    // $in
    test(
      '\$in is represented correctly',
      () => repeat(
        times: testRuns,
        () => _testOperator(
          (arg) => In(List.generate(10, (i) => arg + i)),
          (arg) => '\$in:${List.generate(10, (i) => arg + i).join(',')}',
        ),
      ),
    );

    // $gt
    test(
      '\$gt is represented correctly',
      () => repeat(
        times: testRuns,
        () => _testOperator(Gt.new, (arg) => '\$gt:$arg'),
      ),
    );

    // $gte
    test(
      '\$gte is represented correctly',
      () => repeat(
        times: testRuns,
        () => _testOperator(
          (arg) => Gt(arg, orEqual: true),
          (arg) => '\$gte:$arg',
        ),
      ),
    );

    // $lt
    test(
      '\$lt is represented correctly',
      () => repeat(
        times: testRuns,
        () => _testOperator(Lt.new, (arg) => '\$lt:$arg'),
      ),
    );

    // $lte
    test(
      '\$lte is represented correctly',
      () => repeat(
        times: testRuns,
        () => _testOperator(
          (arg) => Lt(arg, orEqual: true),
          (arg) => '\$lte:$arg',
        ),
      ),
    );

    // $btw
    test(
      '\$btw is represented correctly',
      () => repeat(
        times: testRuns,
        () => _testOperator(
          (arg) => Btw(arg, arg + 50),
          (arg) => '\$btw:$arg,${arg + 50}',
        ),
      ),
    );

    // $ilike
    test(
      '\$ilike is represented correctly',
      () => repeat(
        times: testRuns,
        () => _testOperator((arg) => Ilike('$arg'), (arg) => '\$ilike:$arg'),
      ),
    );

    // $sw
    test(
      '\$sw is represented correctly',
      () => repeat(
        times: testRuns,
        () => _testOperator(
          (arg) => Sw('$arg' * 10),
          (arg) => '\$sw:${'$arg' * 10}',
        ),
      ),
    );

    // $sw
    test(
      '\$contains is represented correctly',
      () => repeat(
        times: testRuns,
        () => _testOperator(
          (arg) => Contains(List.generate(10, (i) => i + arg)),
          (arg) => '\$contains:${List.generate(10, (i) => i + arg).join(',')}',
        ),
      ),
    );

    // $or
    test(
      '\$or is represented correctly',
      () => repeat(
        times: testRuns,
        () => _testOperator(
          (arg) => Or(Eq(arg)),
          (arg) => '\$or:\$eq:$arg',
        ),
      ),
    );

    // $not
    test(
      '\$not is represented correctly',
      () => repeat(
        times: testRuns,
        () => _testOperator(
          (arg) => Not(Eq(arg)),
          (arg) => '\$not:\$eq:$arg',
        ),
      ),
    );
  });

  group('FilterOperators match the examples', () {
    // $eq:Milo
    test(
      'Eq(\'Milo\')',
      () => expect(const Eq('Milo').toString(), equals('\$eq:Milo')),
    );

    // $btw:4,6
    test(
      'Btw(4,6)',
      () => expect(const Btw(4, 6).toString(), equals('\$btw:4,6')),
    );

    // $not:$in:2,5,7
    test(
      'Not(In([2,5,7]))',
      () => expect(
        const Not(In([2, 5, 7])).toString(),
        equals('\$not:\$in:2,5,7'),
      ),
    );

    // $not:$ilike:term
    test(
      'Not(Ilike(\'term\'))',
      () => expect(
        const Not(Ilike('term')).toString(),
        equals('\$not:\$ilike:term'),
      ),
    );

    // $sw:term
    test(
      'Sw(\'term\')',
      () => expect(const Sw('term').toString(), equals('\$sw:term')),
    );

    // $not:$null
    test(
      'Not(Null())',
      () => expect(const Not(Null()).toString(), equals('\$not:\$null')),
    );

    // $btw:2022-02-02,2022-02-10
    test(
      'Btw(\'2022-02-02\',\'2022-02-10\')',
      () => expect(
        const Btw('2022-02-02', '2022-02-10').toString(),
        equals('\$btw:2022-02-02,2022-02-10'),
      ),
    );

    // $lt:2022-12-20T10:00:00.000Z
    test(
      'Lt(\'2022-12-20T10:00:00.000Z\')',
      () => expect(
        const Lt('2022-12-20T10:00:00.000Z').toString(),
        equals('\$lt:2022-12-20T10:00:00.000Z'),
      ),
    );

    // $contains:moderator
    test(
      'Contains([\'moderator\'])',
      () => expect(
        const Contains(['moderator']).toString(),
        equals('\$contains:moderator'),
      ),
    );

    // $contains:moderator,admin
    test(
      'Eq(Milo)',
      () => expect(
        const Contains(['moderator', 'admin']).toString(),
        equals('\$contains:moderator,admin'),
      ),
    );
  });
}

void _testOperator(
  FilterOperator Function(int) operatorSupplier,
  String Function(int) matcherSupplier,
) {
  final arg = rInt();
  final operator = operatorSupplier(arg);
  final matcher = matcherSupplier(arg);

  expect(operator.toString(), equals(matcher));
}
