import 'package:notion_db_sdk/src/module/domain/entity/filters/status_filter.dart';
import 'package:test/test.dart';

void main() {
  group('StatusFilter', () {
    test('constructor should create instance with equals condition', () {
      final filter = StatusFilter('Status', equals: 'In Progress');
      expect(filter.property, equals('Status'));
      expect(filter.equals, equals('In Progress'));
    });

    test('constructor should throw assertion error when multiple conditions are specified', () {
      expect(
        () => StatusFilter('Status', equals: 'In Progress', doesNotEqual: 'Completed'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('constructor should throw assertion error when no condition is specified', () {
      expect(
        () => StatusFilter('Status'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('toMap should return correct map for string condition', () {
      final filter = StatusFilter('Status', equals: 'In Progress');
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Status',
            'status': {'equals': 'In Progress'},
          }));
    });

    test('toMap should return correct map for boolean condition', () {
      final filter = StatusFilter('Status', isNotEmpty: true);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Status',
            'status': {'is_not_empty': true},
          }));
    });

    test('toMap should return correct map for does_not_equal condition', () {
      final filter = StatusFilter('Status', doesNotEqual: 'Completed');
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Status',
            'status': {'does_not_equal': 'Completed'},
          }));
    });
  });
}
