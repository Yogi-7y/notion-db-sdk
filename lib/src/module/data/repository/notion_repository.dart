import 'package:core_y/core_y.dart';
import 'package:network_y/network_y.dart';

import '../../domain/entity/filter.dart';
import '../../domain/entity/property.dart';
import '../../domain/repository/notion_repository.dart';
import '../models/property_factory.dart';
import 'api_request.dart';
import 'pagable.dart';

class NotionRepository implements Repository {
  NotionRepository(this.apiClient);

  final ApiClient apiClient;

  @override
  AsyncResult<Properties, ApiException> query(
  AsyncResult<PaginatedResponse<Properties>, ApiException> query(
    DatabaseId databaseId, {
    Filter? filter,
    PaginationParams? paginationParams,
  }) async {
    final _request = QueryRequest(
      databaseId: databaseId,
      filter: filter,
      paginationParams: paginationParams,
    );

    final result = await apiClient<Map<String, Object?>>(_request);

    return result.map(
      (value) {
        try {
          final _result = <Map<String, Property>>[];

          final _resultsPayload =
              List.castFrom<Object?, Map<String, Object?>>(value['results'] as List<Object?>? ?? [])
                  .toList();

          final _properties =
              _resultsPayload.map((e) => e['properties'] as Map<String, Object?>? ?? {}).toList();

          final _factory = PropertyFactory();

          for (final property in _properties) {
            final _propertyMap = <String, Property>{};

            for (final entry in property.entries) {
              final _property = _factory({entry.key: entry.value});

              _propertyMap[entry.key] = _property;
            }

            _result.add(_propertyMap);
          }

          return _result;
          final hasMore = value['has_more'] as bool? ?? false;
          final nextCursor = value['next_cursor'] as String?;

          return PaginatedResponse(
            results: _result,
            hasMore: hasMore,
            nextCursor: nextCursor,
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
}
