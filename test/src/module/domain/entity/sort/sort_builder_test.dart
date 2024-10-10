import 'package:notion_db_sdk/src/module/domain/entity/sort/sort.dart';
import 'package:notion_db_sdk/src/module/domain/entity/sort/sort_builder.dart';
import 'package:notion_db_sdk/src/module/domain/entity/sort/variants/property_sort.dart';
import 'package:notion_db_sdk/src/module/domain/entity/sort/variants/timestamp_sort.dart';
import 'package:test/test.dart';

void main() {
  group('SortBuilder', () {
    test('builds empty list when no sorts added', () {
      final builder = SortBuilder();
      expect(builder.build(), isEmpty);
    });

    test('adds property sort with default ascending direction', () {
      final builder = SortBuilder()..addPropertySort('Name');
      final sorts = builder.build();
      expect(sorts.length, 1);
      expect(sorts[0], isA<PropertySort>());
      expect((sorts[0] as PropertySort).property, 'Name');
      expect((sorts[0] as PropertySort).direction, SortDirection.ascending);
    });

    test('adds property sort with specified direction', () {
      final builder = SortBuilder()..addPropertySort('Price', direction: SortDirection.descending);
      final sorts = builder.build();
      expect(sorts.length, 1);
      expect(sorts[0], isA<PropertySort>());
      expect((sorts[0] as PropertySort).property, 'Price');
      expect((sorts[0] as PropertySort).direction, SortDirection.descending);
    });

    test('adds timestamp sort with default ascending direction', () {
      final builder = SortBuilder()..addTimestampSort('created_time');
      final sorts = builder.build();
      expect(sorts.length, 1);
      expect(sorts[0], isA<TimestampSort>());
      expect((sorts[0] as TimestampSort).timestamp, 'created_time');
      expect((sorts[0] as TimestampSort).direction, SortDirection.ascending);
    });

    test('adds timestamp sort with specified direction', () {
      final builder = SortBuilder()
        ..addTimestampSort('last_edited_time', direction: SortDirection.descending);
      final sorts = builder.build();
      expect(sorts.length, 1);
      expect(sorts[0], isA<TimestampSort>());
      expect((sorts[0] as TimestampSort).timestamp, 'last_edited_time');
      expect((sorts[0] as TimestampSort).direction, SortDirection.descending);
    });

    test('builds multiple sorts in correct order', () {
      final builder = SortBuilder()
        ..addPropertySort('Name')
        ..addTimestampSort('created_time', direction: SortDirection.descending)
        ..addPropertySort('Price', direction: SortDirection.descending);

      final sorts = builder.build();
      expect(sorts.length, 3);
      expect(sorts[0], isA<PropertySort>());
      expect((sorts[0] as PropertySort).property, 'Name');
      expect((sorts[0] as PropertySort).direction, SortDirection.ascending);
      expect(sorts[1], isA<TimestampSort>());
      expect((sorts[1] as TimestampSort).timestamp, 'created_time');
      expect((sorts[1] as TimestampSort).direction, SortDirection.descending);
      expect(sorts[2], isA<PropertySort>());
      expect((sorts[2] as PropertySort).property, 'Price');
      expect((sorts[2] as PropertySort).direction, SortDirection.descending);
    });

    test('throws assertion error for invalid timestamp', () {
      expect(
        () => SortBuilder().addTimestampSort('invalid_timestamp'),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
