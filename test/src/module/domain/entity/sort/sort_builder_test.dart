import 'package:notion_db_sdk/src/module/domain/entity/sort/sort.dart';
import 'package:notion_db_sdk/src/module/domain/entity/sort/sort_builder.dart';
import 'package:test/test.dart';

void main() {
  group('SortBuilder', () {
    test('builds empty list when no sorts added', () {
      final builder = SortBuilder();
      expect(builder.build(), isEmpty);
    });

    test('adds property sort with default ascending direction', () {
      final builder = SortBuilder()..addPropertySort('Name');
      expect(builder.build(), [
        {'property': 'Name', 'direction': 'ascending'}
      ]);
    });

    test('adds property sort with specified direction', () {
      final builder = SortBuilder()..addPropertySort('Price', direction: SortDirection.descending);
      expect(builder.build(), [
        {'property': 'Price', 'direction': 'descending'}
      ]);
    });

    test('adds timestamp sort with default ascending direction', () {
      final builder = SortBuilder()..addTimestampSort('created_time');
      expect(builder.build(), [
        {'timestamp': 'created_time', 'direction': 'ascending'}
      ]);
    });

    test('adds timestamp sort with specified direction', () {
      final builder = SortBuilder()
        ..addTimestampSort('last_edited_time', direction: SortDirection.descending);
      expect(
        builder.build(),
        [
          {'timestamp': 'last_edited_time', 'direction': 'descending'}
        ],
      );
    });

    test('builds multiple sorts in correct order', () {
      final builder = SortBuilder()
        ..addPropertySort('Name')
        ..addTimestampSort('created_time', direction: SortDirection.descending)
        ..addPropertySort('Price', direction: SortDirection.descending);

      expect(builder.build(), [
        {'property': 'Name', 'direction': 'ascending'},
        {'timestamp': 'created_time', 'direction': 'descending'},
        {'property': 'Price', 'direction': 'descending'},
      ]);
    });

    test('throws assertion error for invalid timestamp', () {
      expect(
        () => SortBuilder().addTimestampSort('invalid_timestamp'),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
