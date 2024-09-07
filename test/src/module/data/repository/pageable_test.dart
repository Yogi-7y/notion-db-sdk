import 'package:notion_db_sdk/src/module/data/repository/api_request.dart';
import 'package:notion_db_sdk/src/module/data/repository/pagable.dart';
import 'package:test/test.dart';

void main() {
  group('PaginationParams', () {
    test('toMap() should return correct map with startCursor', () {
      final params = PaginationParams(startCursor: 'abc123');
      expect(params.toMap(), {'start_cursor': 'abc123'});
    });

    test('toMap() should return correct map with pageSize', () {
      final params = PaginationParams(pageSize: 50);
      expect(params.toMap(), {'page_size': 50});
    });

    test('toMap() should return correct map with both parameters', () {
      final params = PaginationParams(startCursor: 'abc123', pageSize: 50);
      expect(params.toMap(), {'start_cursor': 'abc123', 'page_size': 50});
    });

    test('toMap() should return empty map when no parameters are set', () {
      final params = PaginationParams();
      expect(params.toMap(), isEmpty);
    });
  });

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
