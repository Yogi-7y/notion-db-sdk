import 'package:core_y/core_y.dart';
import 'package:network_y/network_y.dart';
// ignore: implementation_imports
import 'package:network_y/src/exceptions/api_exception.dart';

import '../../domain/repository/notion_repository.dart';
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
        throw UnimplementedError();
      },
    );
  }
}
