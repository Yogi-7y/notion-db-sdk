import 'package:notion_db_sdk/src/module/domain/entity/filters/number_filter.dart';
import 'package:test/test.dart';

void main() {
  group('NumberFilter', () {
    test('constructor should create instance with equals condition', () {
      final filter = NumberFilter('Price', equals: 100);
      expect(filter.property, equals('Price'));
      expect(filter.equals, equals(100));
    });

    test('constructor should throw assertion error when multiple conditions are specified', () {
      expect(
        () => NumberFilter('Price', equals: 100, greaterThan: 50),
        throwsA(isA<AssertionError>()),
      );
    });

    test('constructor should throw assertion error when no condition is specified', () {
      expect(
        () => NumberFilter('Price'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('toMap should return correct map for number condition', () {
      final filter = NumberFilter('Price', greaterThan: 50);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Price',
            'number': {'greater_than': 50},
          }));
    });

    test('toMap should return correct map for boolean condition', () {
      final filter = NumberFilter('Price', isEmpty: true);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Price',
            'number': {'is_empty': true},
          }));
    });

    test('toMap should return correct map for formula property', () {
      final filter = NumberFilter('Price', greaterThan: 50, isFormulaProperty: true);
      final map = filter.toMap();
      expect(
        map,
        equals(
          {
            'property': 'Price',
            'formula': {
              'number': {'greater_than': 50},
            },
          },
        ),
      );
    });
  });
}
