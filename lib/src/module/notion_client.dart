import 'package:core_y/core_y.dart';
import 'package:meta/meta.dart';
import 'package:network_y/network_y.dart';

import '../../notion_db_sdk.dart';
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
    cacheManager: CacheManager<Page>(),
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

  /// Queries a Notion database and returns its properties.
  ///
  /// [databaseId] is the ID of the database to query.
  /// [forceFetchRelationPages] determines whether to resolve relation properties.
  /// When set to true, it automatically fetches the properties of
  /// related pages for any relation properties so they are readily available.

  ///  Example usage:
  /// ```dart
  /// final result = await useCase.fetchPageProperties('page_id');
  /// result.fold(
  ///   onSuccess: (properties) {
  ///     // Accessing a text property
  ///     final titleProperty = properties['Title'] as TextProperty?;
  ///     print('Page title: ${titleProperty?.value}');
  ///
  ///     // Accessing a number property
  ///     final priceProperty = properties['Price'] as Number?;
  ///     print('Price: ${priceProperty?.value}');
  ///
  ///     // Accessing a date property
  ///     final dueDateProperty = properties['Due Date'] as Date?;
  ///     print('Due date: ${dueDateProperty?.value}');
  ///   },
  ///   onFailure: (error) => print('Error: $error'),
  /// );
  /// ```
  ///
  /// It is recommended to set [forceFetchRelationPages] to false if there are many
  /// related pages, as this can lead to a large number of API calls. In that case, it
  /// is recommended to resolve related pages manually as needed.
  ///
  /// Example usage:
  /// ```dart
  /// final result = await useCase.query('database_id', lazyLoadRelations: true);
  ///
  /// result.fold(
  ///   onSuccess: (properties) {
  ///     properties['related_pages'].first.value; // Access the value of the first related
  ///   },
  ///   onFailure: (error) => print('Error: $error'),
  /// );
  /// ```
  /// To resolve the related pages manually later:
  /// ```dart
  ///   final result = await useCase.query('database_id', lazyLoadRelations: false);
  ///
  ///   final properties = result.valueOrNull ?? [];
  ///   final relation = properties['related_pages'].first as RelationProperty;
  ///   await relation.valueDetails?.value.first.resolve(useCase); // Resolve
  ///
  ///   relation.valueDetails?.value.first.value; // Access the value of the first related page
  /// ```
  AsyncResult<Pages, AppException> query(
    DatabaseId databaseId, {
    bool forceFetchRelationPages = false,
    Filter? filter,

    /// When set to true, it'll make the API call for that relation page once.
    /// For subsequent calls, it'll use the cached value.
    /// Cache is only one-pass and is destroyed after the method call.
    bool cacheRelationPages = false,
    PaginationParams? paginationParams,
  }) =>
      _useCase.query(
        databaseId,
        forceFetchRelationPages: forceFetchRelationPages,
        filter: filter,
        cacheRelationPages: cacheRelationPages,
        paginationParams: paginationParams,
      );

  /// Fetches all pages from a Notion database.
  ///
  /// This method will continuously fetch pages until all pages in the database
  /// have been retrieved. It uses pagination internally to fetch all pages.
  ///
  /// [databaseId] is the ID of the database to query.
  /// [pageSize] is the number of items to fetch per page (default is 100, max is 100).
  /// [filter] is an optional filter to apply to the query.
  ///
  /// Returns an [AsyncResult] containing a list of all [RawProperties] in the database,
  /// or an [AppException] if an error occurs.
  ///
  /// WARNING: Use this method with caution, especially with large databases.
  /// Fetching all pages can be time-consuming and resource-intensive for databases
  /// with a large number of pages. Consider using the paginated [query] method
  /// for more controlled data fetching in such cases.
  AsyncResult<Pages, AppException> fetchAll(
    DatabaseId databaseId, {
    int pageSize = 100,
    Filter? filter,
  }) =>
      _useCase.fetchAll(
        databaseId,
        pageSize: pageSize,
        filter: filter,
      );

  AsyncResult<Map<String, Property>, AppException> fetchPageProperties(String pageId) async {
    return _useCase.fetchPageProperties(pageId);
  }

  /// Creates a new page in a Notion database.
  ///
  /// [databaseId] is the ID of the database to create the page in.
  /// [properties] is a list of [Property] objects to set on the new page.
  ///
  ///
  /// Example usage:
  /// ```dart
  /// final properties = [
  ///   TextProperty(
  ///     name: 'Name',
  ///     valueDetails: Value(value: 'New Task'),
  ///     isTitle: true,
  ///   ),
  ///   Number(
  ///     name: 'Priority',
  ///     valueDetails: Value(value: 1),
  ///   ),
  ///   Date(
  ///     name: 'Due Date',
  ///     valueDetails: Value(value: DateTime(2023, 12, 31)),
  ///   ),
  /// ];
  ///
  /// final result = await useCase.createPage(
  ///   databaseId: 'database_id',
  ///   properties: properties,
  /// );
  ///
  /// result.fold(
  ///   onSuccess: (_) => print('Page created successfully'),
  ///   onFailure: (error) => print('Error creating page: $error'),
  /// );
  /// ```

  AsyncResult<void, AppException> createPage({
    required String databaseId,
    required List<Property> properties,
  }) =>
      _useCase.createPage(databaseId: databaseId, properties: properties);

  /// Updates the properties of an existing page in a Notion database.
  ///
  /// [pageId] is the ID of the page to update.
  /// [properties] is a list of [Property] objects to update on the page.
  ///
  /// Example usage:
  /// ```dart
  /// final properties = [
  ///   TextProperty(
  ///     name: 'Name',
  ///     valueDetails: Value(value: 'Updated Task Name'),
  ///   ),
  ///   Number(
  ///     name: 'Priority',
  ///     valueDetails: Value(value: 2),
  ///   ),
  /// ];
  ///
  /// final result = await notionClient.updatePage(
  ///   pageId: 'page_id',
  ///   properties: properties,
  /// );
  ///
  /// result.fold(
  ///   onSuccess: (_) => print('Page updated successfully'),
  ///   onFailure: (error) => print('Error updating page: $error'),
  /// );
  /// ```
  AsyncResult<void, AppException> updatePage({
    required String pageId,
    required List<Property> properties,
  }) =>
      _useCase.updatePage(pageId: pageId, properties: properties);
}
