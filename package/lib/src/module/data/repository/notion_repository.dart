import 'package:core_y/core_y.dart';
import 'package:network_y/network_y.dart';

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
        final _results =
            List.castFrom<Object?, Map<String, Object?>>(value['results'] as List<Object?>? ?? []);

        final _properties =
            _results.map((e) => e['properties'] as Map<String, Object?>? ?? {}).toList();

        final _factory = PropertyFactory();

        // return _properties.map(
        //   (key, value) => MapEntry(
        //     key,
        //     _factory(value as Map<String, Object?>? ?? {}),
        //   ),
        // );
        throw UnimplementedError();
      },
    );
  }
}
