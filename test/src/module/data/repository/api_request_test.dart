import 'package:notion_db_sdk/src/module/data/repository/api_request.dart';
import 'package:notion_db_sdk/src/module/data/repository/pagable.dart';
import 'package:network_y/src/pagination/pagination_params.dart';
import 'package:test/test.dart';

void main() {
  group('QueryRequest', () {
    test('body should include pagination params when provided', () {
      const paginationParams = CursorPaginationStrategyParams(
        cursor: 'abc123',
        limit: 50,
      );

      final request = QueryRequest(
        databaseId: 'db123',
        paginationParams: paginationParams,
      );

      expect(request.body, containsPair('start_cursor', 'abc123'));
      expect(request.body, containsPair('page_size', 50));
    });

    test('body should not include pagination params when not provided', () {
      final request = QueryRequest(databaseId: 'db123');

      expect(request.body, isNot(contains('start_cursor')));
      expect(request.body, isNot(contains('page_size')));
    });

    test('should implement Pageable', () {
      const paginationParams = CursorPaginationStrategyParams(
        cursor: 'abc123',
        limit: 50,
      );
      final request = QueryRequest(
        databaseId: 'db123',
        paginationParams: paginationParams,
      );

      expect(request, isA<Pageable>());
      expect(request.paginationParams, isNotNull);
      expect(request.paginationParams?.cursor, 'abc123');
    });
  });
}
