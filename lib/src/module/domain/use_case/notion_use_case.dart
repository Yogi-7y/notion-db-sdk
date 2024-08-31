// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:core_y/core_y.dart';
import 'package:meta/meta.dart';

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
  });

  final NotionOptions options;
  final Repository repository;

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
  }) async {
    final result = await repository.query(databaseId);

    if (result.isFailure) return result;

    if (!forceFetchRelationPages) return result;

    final properties = result.valueOrNull ?? [];

    for (final propertyMap in properties) {
      for (final property in propertyMap.values) {
        if (property.type == 'relation') {
          final relation = property as RelationProperty;
          final pages = relation.valueDetails?.value ?? [];
          for (final page in pages) {
            await page.resolve(this);
          }
        }
      }
    }

    return Success(properties);
  }

  AsyncResult<Map<String, Property>, AppException> fetchPageProperties(String pageId) async {
    return repository.fetchPageProperties(pageId);
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
  ///   Status(
  ///     name: 'Status',
  ///     valueDetails: Value(value: 'In Progress'),
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
