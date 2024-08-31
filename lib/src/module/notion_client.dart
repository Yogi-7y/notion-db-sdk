import 'package:core_y/core_y.dart';
import 'package:meta/meta.dart';
import 'package:network_y/network_y.dart';

import './domain/use_case/notion_use_case.dart';
import 'data/repository/notion_repository.dart';
import 'domain/entity/property.dart';
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
  AsyncResult<Properties, AppException> query(
    DatabaseId databaseId, {
    bool forceFetchRelationPages = false,
  }) =>
      _useCase.query(
        databaseId,
        forceFetchRelationPages: forceFetchRelationPages,
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
}
