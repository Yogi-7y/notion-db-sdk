import 'package:flutter/material.dart';
import 'package:notion_db_sdk/notion_db_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Notion Database Example')),
        body: const NotionDatabaseExample(),
      ),
    );
  }
}

class NotionDatabaseExample extends StatefulWidget {
  const NotionDatabaseExample({super.key});

  @override
  State<NotionDatabaseExample> createState() => _NotionDatabaseExampleState();
}

class _NotionDatabaseExampleState extends State<NotionDatabaseExample> {
  final NotionClient _notionClient = NotionClient(
    options: const NotionOptions(
      secret: String.fromEnvironment('notion_secret'),
      version: '2022-06-28',
    ),
  );

  late final _testOneDatabaseId = const String.fromEnvironment('test_one_database_id');

  List<Map<String, Property>>? _items;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchNotionProperties();
  }

  Future<void> _fetchNotionProperties() async {
    setState(() => _isLoading = true);

    final result = await _notionClient.query(
      _testOneDatabaseId,
      forceFetchRelationPages: true,
    );

    _items = result.fold(
      onSuccess: (properties) => properties,
      onFailure: (error) {
        print('Error fetching properties: $error');
        return null;
      },
    );
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_items == null) {
      return const Center(child: Text('Failed to load data'));
    }

    return RefreshIndicator(
      onRefresh: _fetchNotionProperties,
      child: ListView.builder(
        itemCount: _items!.length,
        itemBuilder: (context, index) {
          return NotionItemWidget(properties: _items![index]);
        },
      ),
    );
  }
}

class NotionItemWidget extends StatelessWidget {
  final Map<String, Property> properties;

  const NotionItemWidget({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PropertyRow(label: 'Name', property: properties['Name'] as TextProperty?),
            PropertyRow(label: 'Number', property: properties['Number'] as Number?),
            PropertyRow(label: 'Date', property: properties['Date'] as Date?),
            PropertyRow(label: 'Description', property: properties['Description'] as TextProperty?),
            PropertyRow(label: 'Status', property: properties['Status'] as Status?),
            PropertyRow(label: 'Test 2', property: properties['Test 2'] as RelationProperty?),
          ],
        ),
      ),
    );
  }
}

class PropertyRow extends StatelessWidget {
  final String label;
  final Property? property;

  const PropertyRow({super.key, required this.label, this.property});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: _buildPropertyValue()),
        ],
      ),
    );
  }

  Widget _buildPropertyValue() {
    if (property is RelationProperty) {
      final relationProperty = property as RelationProperty;
      final relatedPages = relationProperty.value ?? [];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: relatedPages.map((page) {
          final name = page.properties['Name'] as TextProperty?;
          final number = page.properties['Number'] as Number?;
          return Text('${name?.value ?? 'N/A'} - ${number?.value ?? 'N/A'}');
        }).toList(),
      );
    }
    return Text(property?.value?.toString() ?? 'N/A');
  }
}
