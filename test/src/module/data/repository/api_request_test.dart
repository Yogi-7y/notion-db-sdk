import 'package:notion_db_sdk/src/module/data/repository/api_request.dart';
import 'package:notion_db_sdk/src/module/data/repository/pagable.dart';
import 'package:test/test.dart';

void main() {
  group('QueryRequest', () {
    test('body should include pagination params when provided', () {
      final request = QueryRequest(
        databaseId: 'db123',
        paginationParams: PaginationParams(startCursor: 'abc123', pageSize: 50),
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
      final request = QueryRequest(
        databaseId: 'db123',
        paginationParams: PaginationParams(startCursor: 'abc123'),
      );

      expect(request, isA<Pageable>());
      expect(request.paginationParams, isNotNull);
      expect(request.paginationParams?.startCursor, 'abc123');
    });
  });
}
