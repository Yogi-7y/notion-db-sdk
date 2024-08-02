import 'package:core_y/core_y.dart';
import 'package:network_y/network_y.dart';

import '../../domain/repository/notion_repository.dart';

class NotionRepository implements Repository {
  NotionRepository(this.apiClient);

  final ApiClient apiClient;

  @override
  AsyncResult<Properties, AppException> getProperties(DatabaseId databaseId) {
    throw UnimplementedError();
  }
}
