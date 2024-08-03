import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _options = NotionOptions(
    secret: String.fromEnvironment('NOTION_SECRET'),
    version: '2022-06-28',
  );

  late final _client = NotionClient(options: _options);

  var json = <String, Object?>{};

  Future<void> _fetchJson() async {
    final _result = await _client.getProperties('b624602e46c3492099b7b5559b8cf189');

    print(_result);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notion DB SDK Example'),
        ),
        body: JsonViewer(json),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            _fetchJson();
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
