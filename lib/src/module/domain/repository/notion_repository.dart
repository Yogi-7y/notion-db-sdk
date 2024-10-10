import 'package:core_y/core_y.dart';
import 'package:network_y/src/pagination/pagination_params.dart';

import '../../../../notion_db_sdk.dart';
import '../entity/sort/sort.dart';

typedef DatabaseId = String;
typedef PageId = String;
typedef Pages = List<Page>;
typedef Properties = List<Property>;
typedef RawProperties = List<Map<String, Property>>;

/// Defines the contract for interacting with the Notion API.
///
/// This interface outlines the core operations that can be performed on
/// Notion databases and pages, such as querying, creating pages, and
/// fetching page properties.
abstract class Repository {
  /// Creates a new page in the Notion database.
  AsyncResult<void, AppException> createPage(
    DatabaseId databaseId,
    List<Property> properties,
  );

  /// Fetches the properties of a page.
  AsyncResult<Map<String, Property>, AppException> fetchPageProperties(
    String pageId,
  );

  /// Queries the Notion database and returns a list of properties.
  AsyncResult<PaginatedResponse<Page>, AppException> query(
    DatabaseId databaseId, {
    Filter? filter,
    CursorPaginationStrategyParams? paginationParams,
    List<Sort> sorts = const [],
  });

  AsyncResult<void, AppException> updatePage(
    PageId pageId, {
    required Properties properties,
  });
}
