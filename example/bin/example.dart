// ignore_for_file: do_not_use_environment

import 'package:example/example.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

Future<void> main(List<String> arguments) async {
  const secret = String.fromEnvironment('notion_secret');
  const databaseId = String.fromEnvironment('database_id');
  const pageId = String.fromEnvironment('page_id');
  const version = '2022-06-28';

  log('secret: $secret');

  final client = NotionClient(
    options: const NotionOptions(
      secret: secret,
      version: version,
    ),
  );

  log('Querying database...');
  await queryDatabase(client, databaseId);

  log('\nFetching page properties...');
  await fetchPageProperties(client, pageId);

  log('\nCreating new page...');
  await createNewPage(client, databaseId);
}
