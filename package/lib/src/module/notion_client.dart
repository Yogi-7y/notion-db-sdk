import 'package:core_y/core_y.dart';
import 'package:meta/meta.dart';
import 'package:network_y/network_y.dart';
import './domain/use_case/notion_use_case.dart';
import 'data/repository/notion_repository.dart';
import 'domain/repository/notion_repository.dart';

@immutable
class NotionClient {
  NotionClient({
    required this.options,
  });

  final NotionOptions options;

  late final _useCase = NotionUseCase(
    options: options,
    repository: NotionRepository(
      ApiClient(
        apiExecutor: DioApiExecutor()
          ..setUp(
            request: (
              headers: {
                'Notion-Version': options.version,
                'Authorization': 'Bearer ${options.secret}',
              }
            ),
          ),
      ),
    ),
  );

  AsyncResult<Properties, AppException> getProperties(DatabaseId databaseId) =>
      _useCase.getProperties(databaseId);
}
