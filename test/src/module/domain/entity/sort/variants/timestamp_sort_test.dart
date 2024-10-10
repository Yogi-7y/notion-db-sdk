import 'package:notion_db_sdk/src/module/domain/entity/sort/sort.dart';
import 'package:notion_db_sdk/src/module/domain/entity/sort/variants/timestamp_sort.dart';
import 'package:test/test.dart';

void main() {
  group('TimestampSort', () {
    test('creates TimestampSort with default ascending direction', () {
      final sort = TimestampSort(timestamp: 'created_time');
      expect(sort.timestamp, equals('created_time'));
      expect(sort.direction, equals(SortDirection.ascending));
    });

    test('creates TimestampSort with specified direction', () {
      final sort =
          TimestampSort(timestamp: 'last_edited_time', direction: SortDirection.descending);
      expect(sort.timestamp, equals('last_edited_time'));
      expect(sort.direction, equals(SortDirection.descending));
    });

    test('toMap returns correct representation', () {
      final sort = TimestampSort(timestamp: 'created_time', direction: SortDirection.descending);
      expect(sort.toMap(), equals({'timestamp': 'created_time', 'direction': 'descending'}));
    });

    test('throws assertion error for invalid timestamp', () {
      expect(
        () => TimestampSort(timestamp: 'invalid_timestamp'),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
