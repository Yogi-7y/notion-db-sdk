import 'package:core_y/core_y.dart';
import 'package:network_y/network_y.dart';

import '../../domain/entity/property.dart';
import '../../domain/repository/notion_repository.dart';
import '../models/property_factory.dart';
import 'api_request.dart';

class NotionRepository implements Repository {
  NotionRepository(this.apiClient);

  final ApiClient apiClient;

  @override
  AsyncResult<Properties, ApiException> getPageProperties(DatabaseId databaseId) async {
    final _request = FetchPropertiesRequest(databaseId: databaseId);

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
        } catch (e, s) {
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
}
