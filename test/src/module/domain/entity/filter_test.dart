import 'package:notion_db_sdk/src/module/domain/entity/filter.dart';
import 'package:notion_db_sdk/src/module/domain/entity/filters/number_filter.dart';
import 'package:notion_db_sdk/src/module/domain/entity/filters/text_filter.dart';
import 'package:test/test.dart';

void main() {
  group('AndFilter', () {
    test('constructor should create instance with multiple filters', () {
      final filter = AndFilter([
        TextFilter('Title', contains: 'Project'),
        NumberFilter('Priority', greaterThan: 5),
      ]);
      expect(filter.filters.length, equals(2));
    });

    test('constructor should throw assertion error when less than two filters are provided', () {
      expect(
        () => AndFilter([TextFilter('Title', contains: 'Project')]),
        throwsA(isA<AssertionError>()),
      );
    });

    test('toMap should return correct map structure', () {
      final filter = AndFilter([
        TextFilter('Title', contains: 'Project'),
        NumberFilter('Priority', greaterThan: 5),
      ]);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'and': [
              {
                'property': 'Title',
                'rich_text': {'contains': 'Project'},
              },
              {
                'property': 'Priority',
                'number': {'greater_than': 5},
              },
            ],
          }));
    });

    test('toMap should work with nested AndFilters', () {
      final filter = AndFilter([
        TextFilter('Title', contains: 'Project'),
        AndFilter([
          NumberFilter('Priority', greaterThan: 5),
          TextFilter('Status', equals: 'In Progress'),
        ]),
      ]);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'and': [
              {
                'property': 'Title',
                'rich_text': {'contains': 'Project'},
              },
              {
                'and': [
                  {
                    'property': 'Priority',
                    'number': {'greater_than': 5},
                  },
                  {
                    'property': 'Status',
                    'rich_text': {'equals': 'In Progress'},
                  },
                ],
              },
            ],
          }));
    });
  });

  group('OrFilter', () {
    test('constructor should create instance with multiple filters', () {
      final filter = OrFilter([
        TextFilter('Title', contains: 'Project'),
        NumberFilter('Priority', greaterThan: 5),
      ]);
      expect(filter.filters.length, equals(2));
    });

    test('constructor should throw assertion error when less than two filters are provided', () {
      expect(
        () => OrFilter([TextFilter('Title', contains: 'Project')]),
        throwsA(isA<AssertionError>()),
      );
    });

    test('toMap should return correct map structure', () {
      final filter = OrFilter([
        TextFilter('Title', contains: 'Project'),
        NumberFilter('Priority', greaterThan: 5),
      ]);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'or': [
              {
                'property': 'Title',
                'rich_text': {'contains': 'Project'},
              },
              {
                'property': 'Priority',
                'number': {'greater_than': 5},
              },
            ],
          }));
    });

    test('toMap should work with nested OrFilters', () {
      final filter = OrFilter([
        TextFilter('Title', contains: 'Project'),
        OrFilter([
          NumberFilter('Priority', greaterThan: 5),
          TextFilter('Status', equals: 'In Progress'),
        ]),
      ]);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'or': [
              {
                'property': 'Title',
                'rich_text': {'contains': 'Project'},
              },
              {
                'or': [
                  {
                    'property': 'Priority',
                    'number': {'greater_than': 5},
                  },
                  {
                    'property': 'Status',
                    'rich_text': {'equals': 'In Progress'},
                  },
                ],
              },
            ],
          }));
    });
  });
}
