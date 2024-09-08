// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:core_y/core_y.dart';
import 'package:meta/meta.dart';

import '../../../../notion_db_sdk.dart';
import '../entity/filter.dart';
import '../entity/page.dart';
import '../entity/property.dart';
import '../entity/property_variants/relation.dart';
import '../repository/notion_repository.dart';

/// Represents the core business logic for interacting with the Notion API.
///
/// This class serves as an intermediary between the repository layer and the
/// client, handling any complex business logic required.
class NotionUseCase implements PageResolver {
  /// Creates a new instance of [NotionUseCase].
  ///
  /// [options] contains the Notion API credentials and version.
  /// [repository] is the data source for Notion operations.
  NotionUseCase({
    required this.options,
    required this.repository,
    required this.cacheManager,
  });

  final NotionOptions options;
  final Repository repository;
  final CacheManager<Page> cacheManager;

  /// Queries a Notion database and returns its properties.
  ///
  /// [databaseId] is the ID of the database to query.
  /// [forceFetchRelationPages] determines whether to resolve relation properties.
  /// When set to true, it automatically fetches the properties of
  /// related pages for any relation properties so they are readily available.

  AsyncResult<Properties, AppException> query(
    DatabaseId databaseId, {
    bool forceFetchRelationPages = false,

    /// When set to true, it'll make the API call for that relation page once.
    /// For subsequent calls, it'll use the cached value.
    /// Cache is only one-pass and is destroyed after the method call.
    bool cacheRelationPages = false,
    Filter? filter,
    PaginationParams? paginationParams,
  }) async {
    final result = await repository.query(
      databaseId,
      filter: filter,
      paginationParams: paginationParams,
    );

    if (result.isFailure) return Failure((result as Failure).error);

    if (!forceFetchRelationPages) return result.map((value) => value.results);

    final properties = result.valueOrNull?.results ?? [];

    KeepAliveLink? _cacheKeepAliveLink;

    for (final propertyMap in properties) {
      for (final property in propertyMap.values) {
        if (property.type == 'relation') {
          final relation = property as RelationProperty;
          final pages = relation.valueDetails?.value ?? [];
          for (final page in pages) {
            if (!cacheRelationPages) {
              await page.resolve(this);
            } else {
              final _page = cacheManager.get(page.id);

              if (_page != null) {
                page.properties = _page.properties;
              } else {
                await page.resolve(this);
                _cacheKeepAliveLink = cacheManager.set(page.id, page);
              }
            }
          }
        }
      }
    }

    _cacheKeepAliveLink?.expire();

    return Success(properties);
  }

  AsyncResult<List<Map<String, Property>>, AppException> fetchAll(
    DatabaseId databaseId, {
    int pageSize = 100,
    Filter? filter,
  }) async {
    final allProperties = <Map<String, Property>>[];
    String? nextCursor;

    do {
      final result = await repository.query(
        databaseId,
        filter: filter,
        paginationParams: PaginationParams(
          startCursor: nextCursor,
          pageSize: pageSize,
        ),
      );

      if (result is Failure) {
        final _result = result as Failure;
        return Failure(_result.error);
      }

      final paginatedResponse = result.valueOrNull;

      allProperties.addAll(paginatedResponse?.results ?? []);
      nextCursor = paginatedResponse?.nextCursor;
      print('nextCursor: $nextCursor');
    } while (nextCursor != null);

    return Success(allProperties);
  }

  AsyncResult<Map<String, Property>, AppException> fetchPageProperties(String pageId) async {
    return repository.fetchPageProperties(pageId);
  }

  /// Creates a new page in a Notion database.
  ///
  /// [databaseId] is the ID of the database to create the page in.
  /// [properties] is a list of [Property] objects to set on the new page.
  AsyncResult<void, AppException> createPage({
    required String databaseId,
    required List<Property> properties,
  }) async {
    return repository.createPage(databaseId, properties);
  }

  @protected
  @override
  AsyncResult<Map<String, Property<Object>>, AppException> resolve(
    String pageId,
  ) =>
      fetchPageProperties(pageId);
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
