# Notion DB SDK

A type-safe structured way to interact with Notion APIs. This client handles structured data from Notion databases, focusing on property management while ignoring embedded styles, page blocks, and other non-database elements.

![Diagram](https://raw.githubusercontent.com/Yogi-7y/notion-db-sdk/main/assets/diagram.png)

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

  // Fetch properties from a database
  final result = await client.getProperties('database_id');

  result.fold(
    (properties) {
      // Handle successful response
    },
    (error) {
      // Handle error
    },
  );
}
```

## Understanding Notion Properties

In Notion, properties define the structure and type of information stored in database. This SDK mimics Notion's property structure, making it easy to read and write data while ignoring styling information and complex nested structures.

The main advantage of this package is its simplicity in reading from and writing to Notion databases. It abstracts away the complex JSON structures typically required in direct API calls.

## SDK vs Direct API Calls

### Reading Properties

With direct API calls, reading properties will involve handling this:

```json
{
  "Description": {
    "id": "a%7BUf",
    "type": "rich_text",
    "rich_text": [
      {
        "type": "text",
        "text": {
          "content": "A dark sky",
          "link": null
        },
        "annotations": {
          "bold": false,
          "italic": false,
          "strikethrough": false,
          "underline": false,
          "code": false,
          "color": "default"
        },
        "plain_text": "A dark sky",
        "href": null
      }
    ]
  },
  "Price": {
    "id": "uCG%3A",
    "type": "number",
    "number": 42
  },
  "Due Date": {
    "id": "%5E%7Cny",
    "type": "date",
    "date": {
      "start": "2023-02-23",
      "end": null,
      "time_zone": null
    }
  }
}
```

With this SDK, value can be easily accessed as:

```dart
page.properties['Description'].value // "A dark sky"
page.properties['Price'].value // 42
page.properties['Due Date'].value // DateTime(2023, 2, 23)
```

### Writing Properties

To create a new page with a title, a number property, and a date property using direct API calls:

```json
{
  "parent": { "database_id": "your_database_id" },
  "properties": {
    "Name": {
      "title": [
        {
          "text": {
            "content": "New Page Title"
          }
        }
      ]
    },
    "Price": {
      "number": 42
    },
    "Due Date": {
      "date": {
        "start": "2023-05-20"
      }
    }
  }
}
```

With this SDK, the same operation is simplified to:

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

### Fetching Properties

To fetch properties from a Notion database:

```dart
final databaseId = 'your_database_id';
final result = await client.getProperties(databaseId);

result.fold(
  (properties) {
    // Handle successful response
  },
  (error) {
    // Handle error
    print('Error: $error');
  },
);
```

### Creating a New Page

To create a new page in a Notion database:

```dart
final databaseId = 'your_database_id';
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
  // Add more properties as needed
];

final result = await client.createPage(
  databaseId: databaseId,
  properties: properties,
);

result.fold(
  (_) {
    print('Page created successfully');
  },
  (error) {
    print('Error creating page: $error');
  },
);
```

## Filter

### Single Filter

To use a single filter, you can create an instance of the appropriate filter class and pass it to the `query` method. Here's an example using a `TextFilter`:

```dart
final filter = TextFilter('Title', contains: 'Foo');

final result = await client.query(
  databaseId,
  filter: filter,
);

result.fold(
  (properties) {
    // Handle filtered results
  },
  (error) {
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
  databaseId,
  filter: filter,
);
```

This query will return pages where the 'Title' contains 'Foo' AND the 'Priority' is greater than 5.
Similaly, you can use `OrFilter`

```dart
final filter = OrFilter([
  TextFilter('Status', equals: 'In Progress'),
  TextFilter('Status', equals: 'Review'),
]);
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
  databaseId,
  filter: filter,
);
```

This query will return pages where the 'Title' contains 'Foo' AND either the 'Priority' is greater than 8 OR the 'DueDate' is before the current date.

---

Happy coding! 💻✨
