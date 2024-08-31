// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:core_y/core_y.dart';
import 'package:meta/meta.dart';

import '../entity/property.dart';
import '../entity/property_variants/relation.dart';
import '../repository/notion_repository.dart';

class NotionUseCase {
  NotionUseCase({
    required this.options,
    required this.repository,
  });

  final NotionOptions options;
  final Repository repository;

  AsyncResult<Properties, AppException> query(
    DatabaseId databaseId, {
    bool lazyLoadRelations = true,
  }) async {
    final result = await repository.query(databaseId);

    if (result.isFailure) return result;

    if (!lazyLoadRelations) return result;

    final properties = result.valueOrNull ?? [];

    for (final propertyMap in properties) {
      for (final property in propertyMap.values) {
        if (property.type == 'relation') {
          final relation = property as RelationProperty;
          final pages = relation.valueDetails?.value ?? [];
          for (final page in pages) {
            await page.resolve(fetchPageProperties);
          }
        }
      }
    }

    return Success(properties);
  }

  AsyncResult<Map<String, Property>, AppException> fetchPageProperties(String pageId) async {
    return repository.fetchPageProperties(pageId);
  }

  AsyncResult<void, AppException> createPage({
    required String databaseId,
    required List<Property> properties,
  }) async {
    return repository.createPage(databaseId, properties);
  }
}

@immutable
class NotionOptions {
  const NotionOptions({
    required this.secret,
    required this.version,
  });
  final String secret;
  final String version;

  @override
  String toString() => 'NotionOptions(secret: $secret, version: $version)';

  @override
  bool operator ==(covariant NotionOptions other) {
    if (identical(this, other)) return true;

    return other.secret == secret && other.version == version;
  }

  @override
  int get hashCode => secret.hashCode ^ version.hashCode;
}
