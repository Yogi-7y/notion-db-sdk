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
    secret: const String.fromEnvironment('SECRET'),
    version: '2022-06-28',
  );

  late final _client = NotionClient(options: _options);

  var _pages = <Map<String, Property>>[];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchJson();
    });
  }

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

  Future<void> createPage() async {
    final title = TextProperty(
      name: 'Name',
      isTitle: true,
      valueDetails: Value(value: 'From SDK'),
    );

    final _result = await _client.createPage(
      databaseId: 'b624602e46c3492099b7b5559b8cf189',
      properties: [title],
    );

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
        body: ListView.separated(
          itemCount: _pages.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final _page = _pages[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _page.entries
                  .map(
                    (e) => Tile(
                      propertyName: e.key,
                      property: e.value,
                    ),
                  )
                  .toList(),
            );
          },
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () async {
                _fetchJson();
              },
              child: const Icon(Icons.refresh),
            ),
            SizedBox(width: 8),
            FloatingActionButton(
              onPressed: () async {
                createPage();
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

@immutable
class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.propertyName,
    required this.property,
  });

  final String propertyName;
  final Property property;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(propertyName),
        SizedBox(width: 8),
        Text(property.value.toString()),
      ],
    );
  }
}
