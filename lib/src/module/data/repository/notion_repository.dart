import 'package:core_y/core_y.dart';
import 'package:network_y/network_y.dart';
import 'package:network_y/src/pagination/pagination_params.dart';

import '../../../../notion_db_sdk.dart';
import '../../domain/entity/sort/sort.dart';
import '../../domain/repository/notion_repository.dart';
import '../models/property_factory.dart';
import 'api_request.dart';

class NotionRepository implements Repository {
  NotionRepository(this.apiClient);

  final ApiClient apiClient;

  @override
  AsyncResult<PaginatedResponse<Page>, ApiException> query(
    DatabaseId databaseId, {
    Filter? filter,
    CursorPaginationStrategyParams? paginationParams,
    List<Sort> sorts = const [],
  }) async {
    final _request = QueryRequest(
      databaseId: databaseId,
      filter: filter,
      paginationParams: paginationParams,
      sorts: sorts,
    );

    print('Request: $_request');

    final result = await apiClient<Map<String, Object?>>(_request);

    return result.map(
      (value) {
        try {
          final _result = <Page>[];

          final _resultsPayload =
              List.castFrom<Object?, Map<String, Object?>>(value['results'] as List<Object?>? ?? [])
                  .toList();

          final _factory = PropertyFactory();

          for (final pageData in _resultsPayload) {
            final pageId = pageData['id'] as String;
            final properties = pageData['properties'] as Map<String, Object?>? ?? {};

            final parsedProperties = <String, Property>{};
            for (final entry in properties.entries) {
              final _property = _factory({entry.key: entry.value});
              parsedProperties[entry.key] = _property;
            }

            _result.add(Page(id: pageId, properties: parsedProperties));
          }

          final hasMore = value['has_more'] as bool? ?? false;
          final nextCursor = value['next_cursor'] as String?;

          return PaginatedResponse<Page>(
            results: _result,
            hasMore: hasMore,
            paginationParams: CursorPaginationStrategyParams(
              limit: paginationParams?.limit ?? 100,
              cursor: nextCursor,
            ),
          );
        } catch (e) {
          rethrow;
        }
      },
    );
  }

  @override
  AsyncResult<Map<String, Property>, ApiException> fetchPageProperties(String pageId) async {
    final _request = FetchPagePropertiesRequest(pageId: pageId);

    final result = await apiClient<Map<String, Object?>>(_request);

    return result.map(
      (value) {
        try {
          final _properties = value['properties'] as Map<String, Object?>? ?? {};
          return _parseProperties(_properties);
        } catch (e) {
          rethrow;
        }
      },
    );
  }

  @override
  AsyncResult<void, AppException> createPage(
    DatabaseId databaseId,
    List<Property> properties,
  ) {
    final _request = CreatePageRequest(
      databaseId: databaseId,
      properties: properties,
    );

    return apiClient<void>(_request);
  }

  Map<String, Property> _parseProperties(Map<String, Object?> properties) {
    final _result = <String, Property>{};
    final _factory = PropertyFactory();

    for (final entry in properties.entries) {
      final _property = _factory({entry.key: entry.value});
      _result[entry.key] = _property;
    }

    return _result;
  }

  @override
  AsyncResult<void, AppException> updatePage(
    PageId pageId, {
    required Properties properties,
  }) {
    final _request = UpdatePagePropertiesRequest(
      pageId: pageId,
      properties: properties,
    );

    return apiClient<void>(_request);
  }
}
