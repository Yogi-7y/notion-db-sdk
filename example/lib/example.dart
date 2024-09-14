import 'package:network_y/src/exceptions/api_exception.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

Future<void> queryDatabase(
  NotionClient client,
  String databaseId, {
  Filter? filter,
  PaginationParams? paginationParams,
}) async {
  logHeader('Querying database');

  log('Filter: ${filter?.toMap()}');
  log('Pagination params: ${paginationParams?.toMap()}');
  logBlankLine();

  final result = await client.query(
    databaseId,
    filter: filter,
    paginationParams: paginationParams,
  );

  result.fold(
    onSuccess: (pages) {
      log('Results:');
      log('Total Count: ${pages.length}');
      for (final page in pages) {
        final properties = page.properties;
        final number = pages.indexOf(page) + 1;
        log('$number. ${properties['Name']?.value}');
      }
      logBlankLine();
    },
    onFailure: (error) {
      log('Error querying database: $error');

      if (error is ApiException) {
        log('Status code: ${error.statusCode}');
        log('Response: ${error.response}');
        log('Request: ${error.request.url}');
      }
    },
  );
}

Future<void> fetchAll(
  NotionClient client,
  String databaseId,
) async {
  logHeader('Fetch all ');

  logBlankLine();
  log('Database id: $databaseId');

  final result = await client.fetchAll(
    databaseId,
    pageSize: 5,
  );

  result.fold(
    onSuccess: (pages) {
      log('Results:');
      log('Total Count: ${pages.length}');
      for (final page in pages) {
        final number = pages.indexOf(page) + 1;
        final properties = page.properties;
        log('$number. ${properties['Name']?.value}');
      }
      logBlankLine();
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

Future<void> updatePage(NotionClient client, String pageId) async {
  final properties = <Property>[
    const TextProperty(
      name: 'Name',
      valueDetails: Value(value: 'Updated name'),
      isTitle: true,
    ),
  ];

  final result = await client.updatePage(
    pageId: pageId,
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

void logHeader(String name) {
  logBlankLine();
  log('--------------- $name ---------------');
  logBlankLine();
}

void logBlankLine() {
  log('\n');
}

void log(String message) {
  // ignore: avoid_print
  print(message);
}
