import 'package:notion_db_sdk/src/module/domain/entity/filter.dart';
import 'package:notion_db_sdk/src/module/domain/entity/filter_builder.dart';
import 'package:notion_db_sdk/src/module/domain/entity/filters/number_filter.dart';
import 'package:test/test.dart';

void main() {
  group('FilterBuilder', () {
    test('should build an AndFilter', () {
      final filter = FilterBuilder().and([
        NumberFilter('Price', greaterThanOrEqualTo: 100),
        NumberFilter('Quantity', lessThan: 50),
      ]).build();

      expect(filter, isA<AndFilter>());
      expect((filter as AndFilter).filters.length, equals(2));
      expect(
          filter.toMap(),
          equals({
            'and': [
              {
                'property': 'Price',
                'number': {'greater_than_or_equal_to': 100},
              },
              {
                'property': 'Quantity',
                'number': {'less_than': 50},
              },
            ],
          }));
    });

    test('should build an OrFilter', () {
      final filter = FilterBuilder().or([
        NumberFilter('Rating', equals: 5),
        NumberFilter('Rating', isNotEmpty: true),
      ]).build();

      expect(filter, isA<OrFilter>());
      expect((filter as OrFilter).filters.length, equals(2));
      expect(
          filter.toMap(),
          equals({
            'or': [
              {
                'property': 'Rating',
                'number': {'equals': 5},
              },
              {
                'property': 'Rating',
                'number': {'is_not_empty': true},
              },
            ],
          }));
    });

    test('should build a complex nested filter', () {
      final filter = FilterBuilder().and([
        NumberFilter('Price', greaterThanOrEqualTo: 100),
        NumberFilter('Quantity', lessThan: 50),
        OrFilter([
          NumberFilter('Rating', equals: 5),
          NumberFilter('Rating', isNotEmpty: true),
        ]),
      ]).build();

      expect(filter, isA<AndFilter>());
      expect((filter as AndFilter).filters.length, equals(3));
      expect(
          filter.toMap(),
          equals({
            'and': [
              {
                'property': 'Price',
                'number': {'greater_than_or_equal_to': 100},
              },
              {
                'property': 'Quantity',
                'number': {'less_than': 50},
              },
              {
                'or': [
                  {
                    'property': 'Rating',
                    'number': {'equals': 5},
                  },
                  {
                    'property': 'Rating',
                    'number': {'is_not_empty': true},
                  },
                ],
              },
            ],
          }));
    });

    test('should throw StateError when no filter is set', () {
      expect(
        () => FilterBuilder().build(),
        throwsA(isA<StateError>()),
      );
    });
  });
}
