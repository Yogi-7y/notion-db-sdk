import 'package:notion_db_sdk/notion_db_sdk.dart';
import 'package:network_y/src/exceptions/api_exception.dart';

Future<void> queryDatabase(
  NotionClient client,
  String databaseId, {
  Filter? filter,
}) async {
  final result = await client.query(
    databaseId,
    filter: filter,
  );

  result.fold(
    onSuccess: (properties) {
      log('Database query successful:');

      for (final entry in properties) {
        for (final property in entry.entries) {
          log('${property.key}: ${property.value.value}');
        }
        log('---');
      }
    },
    onFailure: (error) => log('Error querying database: $error'),
  );
}

Future<void> fetchPageProperties(NotionClient client, String pageId) async {
  final result = await client.fetchPageProperties(pageId);

  result.fold(
    onSuccess: (properties) {
      log('Page properties:');
      for (final property in properties.entries) {
        log('${property.key}: ${property.value.value}');
      }
    },
    onFailure: (error) => log('Error fetching page properties: $error'),
  );
}

Future<void> createNewPage(NotionClient client, String databaseId) async {
  final properties = <Property>[
    const TextProperty(
      name: 'Name',
      valueDetails: Value(value: 'New Task from SDK'),
      isTitle: true,
    ),
    const Status(
      name: 'Status',
      valueDetails: Value(value: 'In progress'),
    ),
  ];

  final result = await client.createPage(
    databaseId: databaseId,
    properties: properties,
  );

  result.fold(
    onSuccess: (_) => log('Page created successfully'),
    onFailure: (error) {
      log('Error creating page: $error');
      if (error is ApiException) {
        log('Status code: ${error.statusCode}');
        log('Response: ${error.response}');
      }
    },
  );
}

void log(String message) {
  // ignore: avoid_print
  print(message);
}
