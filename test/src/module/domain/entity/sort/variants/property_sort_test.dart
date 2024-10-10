import 'package:notion_db_sdk/src/module/domain/entity/sort/sort.dart';
import 'package:notion_db_sdk/src/module/domain/entity/sort/variants/property_sort.dart';
import 'package:test/test.dart';

void main() {
  group('PropertySort', () {
    test('creates PropertySort with default ascending direction', () {
      final sort = PropertySort(property: 'Name');
      expect(sort.property, equals('Name'));
      expect(sort.direction, equals(SortDirection.ascending));
    });

    test('creates PropertySort with specified direction', () {
      final sort = PropertySort(property: 'Price', direction: SortDirection.descending);
      expect(sort.property, equals('Price'));
      expect(sort.direction, equals(SortDirection.descending));
    });

    test('toMap returns correct representation', () {
      final sort = PropertySort(property: 'Name', direction: SortDirection.descending);
      expect(sort.toMap(), equals({'property': 'Name', 'direction': 'descending'}));
    });

    test('throws assertion error for empty property name', () {
      expect(
        () => PropertySort(property: ''),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
