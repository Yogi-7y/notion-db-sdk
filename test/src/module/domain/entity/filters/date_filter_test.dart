import 'package:notion_db_sdk/src/module/domain/entity/filters/date_filter.dart';
import 'package:test/test.dart';

void main() {
  group('DateFilter', () {
    test('constructor should create instance with equals condition', () {
      final date = DateTime(2023);
      final filter = DateFilter('Due Date', equals: date);
      expect(filter.property, equals('Due Date'));
      expect(filter.equals, equals(date));
    });

    test('constructor should throw assertion error when multiple conditions are specified', () {
      expect(
        () => DateFilter('Due Date', equals: DateTime.now(), before: DateTime.now()),
        throwsA(isA<AssertionError>()),
      );
    });

    test('constructor should throw assertion error when no condition is specified', () {
      expect(
        () => DateFilter('Due Date'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('toMap should return correct map for date condition', () {
      final date = DateTime(2023);
      final filter = DateFilter('Due Date', equals: date);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Due Date',
            'date': {'equals': '2023-01-01T00:00:00.000'},
          }));
    });

    test('toMap should return correct map for boolean condition', () {
      final filter = DateFilter('Due Date', pastWeek: true);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Due Date',
            'date': {'past_week': <String, Object?>{}},
          }));
    });

    test('toMap should return correct map for formula property', () {
      final filter = DateFilter('Due Date', equals: DateTime(2023, 5, 1), isFormulaProperty: true);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Due Date',
            'formula': {
              'date': {'equals': '2023-05-01T00:00:00.000'},
            },
          }));
    });
  });
}
