import 'package:notion_db_sdk/notion_db_sdk.dart';
import 'package:notion_db_sdk/src/module/data/repository/api_request.dart';
import 'package:notion_db_sdk/src/module/domain/entity/filter.dart';
import 'package:notion_db_sdk/src/module/domain/entity/sort/sort.dart';
import 'package:notion_db_sdk/src/module/domain/entity/sort/variants/property_sort.dart';
import 'package:notion_db_sdk/src/module/domain/entity/sort/variants/timestamp_sort.dart';
import 'package:network_y/src/pagination/pagination_params.dart';
import 'package:test/test.dart';

void main() {
  group('QueryRequest', () {
    const databaseId = 'test_database_id';

    test('body includes all parameters when provided', () {
      final filter = AndFilter([
        TextFilter('Name', contains: 'Test'),
        NumberFilter('Price', greaterThan: 10),
      ]);

      final sorts = [
        PropertySort(property: 'Name'),
        TimestampSort(timestamp: 'created_time', direction: SortDirection.descending),
      ];

      const paginationParams = CursorPaginationStrategyParams(
        cursor: 'next_cursor',
        limit: 50,
      );

      final request = QueryRequest(
        databaseId: databaseId,
        filter: filter,
        sorts: sorts,
        paginationParams: paginationParams,
      );

      expect(request.body, {
        'filter': {
          'and': [
            {
              'property': 'Name',
              'rich_text': {'contains': 'Test'},
            },
            {
              'property': 'Price',
              'number': {'greater_than': 10},
            },
          ],
        },
        'sorts': [
          {'property': 'Name', 'direction': 'ascending'},
          {'timestamp': 'created_time', 'direction': 'descending'},
        ],
        'start_cursor': 'next_cursor',
        'page_size': 50,
      });
    });

    test('body excludes optional parameters when not provided', () {
      final request = QueryRequest(databaseId: databaseId);

      expect(request.body, isEmpty);
    });
  });
}
