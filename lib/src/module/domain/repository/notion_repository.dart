import 'package:core_y/core_y.dart';
// ignore: implementation_imports

import '../../data/repository/pagable.dart';
import '../entity/filter.dart';
import '../entity/property.dart';

typedef Properties = List<Map<String, Property>>;

typedef DatabaseId = String;

/// Defines the contract for interacting with the Notion API.
///
/// This interface outlines the core operations that can be performed on
/// Notion databases and pages, such as querying, creating pages, and
/// fetching page properties.
abstract class Repository {
  /// Queries the Notion database and returns a list of properties.
  AsyncResult<PaginatedResponse<Properties>, AppException> query(
    DatabaseId databaseId, {
    Filter? filter,
    PaginationParams? paginationParams,
  });

  /// Creates a new page in the Notion database.
  AsyncResult<void, AppException> createPage(
    DatabaseId databaseId,
    List<Property> properties,
  );

  /// Fetches the properties of a page.
  AsyncResult<Map<String, Property>, AppException> fetchPageProperties(
    String pageId,
  );
}
