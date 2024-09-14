// ignore_for_file: do_not_use_environment

import 'package:example/constants.dart';
import 'package:example/example.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

Future<void> main(List<String> arguments) async {
  log('secret: $secret');

  final client = NotionClient(
    options: const NotionOptions(
      secret: secret,
      version: version,
    ),
  );

  final filter = NumberFilter('Number', greaterThan: 40);

  await queryDatabase(
    client,
    testDatabaseId,
    filter: filter,
  );

  await updatePage(client, pageId);
}
