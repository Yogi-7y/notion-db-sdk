import 'package:flutter/material.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property.dart';

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

  var _pages = <Map<String, Property>>[];

  Future<void> _fetchJson() async {
    final _result = await _client.getProperties('b624602e46c3492099b7b5559b8cf189');

    print(_result);

    _result.fold(
      onSuccess: (value) {
        _pages = value;
        setState(() {});
      },
      onFailure: (error) {
        print('Failed to fetch properties: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notion DB SDK Example'),
        ),
        body: ListView.separated(
          itemCount: _pages.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final _page = _pages[index];

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: _page.entries
                  .map(
                    (e) => Column(
                      children: [
                        Text(e.key),
                        Text(e.value.toString()),
                      ],
                    ),
                  )
                  .toList(),
            );
          },
        ),
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
