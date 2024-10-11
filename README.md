# Notion DB SDK

A type-safe structured way to interact with Notion APIs. This client handles structured data from Notion databases, focusing on property management while ignoring embedded styles, page blocks, and other non-database elements.

One rule that this package abides by:

> Only deal with raw, structured data in a type-safe way and ignore all the fluffy stuff like styling, formatting, page blocks, etc.

## Quick Start

```dart
import 'package:notion_db_sdk/notion_db_sdk.dart';

void main() async {
  // Initialize the NotionClient
  final client = NotionClient(
    options: NotionOptions(
      secret: 'your_notion_api_secret',
      version: 'your_notion_api_version',
    ),
  );

  // Query a database
  final result = await client.query('database_id');

  result.fold(
    onSuccess: (paginatedResponse) {
      // Handle successful response
      final pages = paginatedResponse.results;
      for (final page in pages) {
        // Access page properties
        print(page.properties['Title']?.value);
      }
    },
    onFailure: (error) {
      // Handle error
      print('Error: $error');
    },
  );
}
```

## Understanding Notion Properties

In Notion, properties define the structure and type of information stored in databases. This SDK mimics Notion's property structure, making it easy to read and write data while ignoring styling information and complex nested structures.

The main advantage of this package is its simplicity in reading from and writing to Notion databases. It abstracts away the complex JSON structures typically required in direct API calls.

## SDK vs Direct API Calls

### Reading Properties

With direct API calls, reading properties involves handling complex JSON structures. With this SDK, values can be easily accessed as:

```dart
page.properties['Description'].value // "A dark sky"
page.properties['Price'].value // 42
page.properties['Due Date'].value // DateTime(2023, 2, 23)
```

### Writing Properties

Creating a new page with properties using this SDK is simplified:

```dart
final properties = [
  TextProperty(
    name: 'Name',
    valueDetails: Value(value: 'New Page Title'),
    isTitle: true,
  ),
  Number(
    name: 'Price',
    valueDetails: Value(value: 42),
  ),
  Date(
    name: 'Due Date',
    valueDetails: Value(value: DateTime(2023, 5, 20)),
  ),
];

await client.createPage(
  databaseId: 'your_database_id',
  properties: properties,
);
```

## Usage

### Initializing the Client

To use the Notion DB SDK, first initialize the `NotionClient` with your API credentials:

```dart
final client = NotionClient(
  options: NotionOptions(
    secret: 'your_notion_api_secret',
    version: 'your_notion_api_version',
  ),
);
```

### Querying a Database

To query a Notion database:

```dart
final result = await client.query('your_database_id');

result.fold(
  onSuccess: (paginatedResponse) {
    final pages = paginatedResponse.results;
    // Handle successful response
  },
  onFailure: (error) {
    // Handle error
    print('Error: $error');
  },
);
```

### Creating a New Page

To create a new page in a Notion database:

```dart
final properties = [
  TextProperty(
    name: 'Name',
    valueDetails: Value(value: 'New Page Title'),
    isTitle: true,
  ),
  Number(
    name: 'Price',
    valueDetails: Value(value: 42),
  ),
  Date(
    name: 'Due Date',
    valueDetails: Value(value: DateTime(2023, 5, 20)),
  ),
];

final result = await client.createPage(
  databaseId: 'your_database_id',
  properties: properties,
);

result.fold(
  onSuccess: (_) {
    print('Page created successfully');
  },
  onFailure: (error) {
    print('Error creating page: $error');
  },
);
```

### Updating a Page

To update an existing page in a Notion database:

```dart
final properties = [
  TextProperty(
    name: 'Name',
    valueDetails: Value(value: 'Updated Task Name'),
  ),
  Number(
    name: 'Priority',
    valueDetails: Value(value: 2),
  ),
];

final result = await client.updatePage(
  pageId: 'page_id',
  properties: properties,
);

result.fold(
  onSuccess: (_) {
    print('Page updated successfully');
  },
  onFailure: (error) {
    print('Error updating page: $error');
  },
);
```

## Filtering

### Single Filter

To use a single filter, create an instance of the appropriate filter class and pass it to the `query` method:

```dart
final filter = TextFilter('Title', contains: 'Foo');

final result = await client.query(
  'database_id',
  filter: filter,
);

result.fold(
  onSuccess: (paginatedResponse) {
    // Handle filtered results
  },
  onFailure: (error) {
    // Handle error
  },
);
```

### Filter Operators

You can combine multiple filters using `AndFilter` and `OrFilter`:

```dart
final filter = AndFilter([
  TextFilter('Title', contains: 'Foo'),
  NumberFilter('Priority', greaterThan: 5),
]);

final result = await client.query(
  'database_id',
  filter: filter,
);
```

### Nested Filters

You can create complex queries by nesting AND and OR filters:

```dart
final filter = AndFilter([
  TextFilter('Title', contains: 'Foo'),
  OrFilter([
    NumberFilter('Priority', greaterThan: 8),
    DateFilter('DueDate', before: DateTime.now()),
  ]),
]);

final result = await client.query(
  'database_id',
  filter: filter,
);
```

## Sorting

You can sort the query results using the `SortBuilder`:

```dart
final sortBuilder = SortBuilder()
  ..addPropertySort('Name')
  ..addTimestampSort('created_time', direction: SortDirection.descending);

final sorts = sortBuilder.build();

final result = await client.query(
  'database_id',
  sorts: sorts,
);
```

## Pagination

The `query` method supports pagination:

```dart
final paginationParams = CursorPaginationStrategyParams(
  limit: 50,
  cursor: 'next_cursor_from_previous_query',
);

final result = await client.query(
  'database_id',
  paginationParams: paginationParams,
);

result.fold(
  onSuccess: (paginatedResponse) {
    final pages = paginatedResponse.results;
    final nextCursor = paginatedResponse.paginationParams.cursor;
    // Use nextCursor for the next query if there are more results
  },
  onFailure: (error) {
    // Handle error
  },
);
```

## Force Fetch Related Pages

The `forceFetchRelationPages` option in the query method allows you to automatically resolve and fetch properties for related pages in a single query. This can be particularly useful when you need immediate access to the properties of related pages without making separate API calls.

```dart
final result = await useCase.query('database_id', forceFetchRelationPages: true);

result.fold(
  onSuccess: (properties) {
    properties['related_pages'].first.value; // Access the value of the first related
  },
  onFailure: (error) => print('Error: $error'),
);
```

It provides the convenience to fetch all the related pages in a single query and use values in one go. It is recommended to set [forceFetchRelationPages] to false if there are many related pages, as this can lead to a large number of API calls. In that case, it is recommended to resolve related pages manually as needed.

```dart
final result = await useCase.query('database_id');

final properties = result.valueOrNull ?? [];
final relation = properties['related_pages'].first as RelationProperty;
await relation.valueDetails?.value.first.resolve(useCase); // Resolve

relation.valueDetails?.value.first.value; // Access the value of the first related page
```

For databases with a large number of relation properties or when you don't immediately need all related data, consider fetching related pages selectively to optimize performance and API usage.

---

Happy coding! 💻✨
