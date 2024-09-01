import 'package:notion_db_sdk/src/module/domain/entity/filters/text_filter.dart';
import 'package:test/test.dart';

void main() {
  group('TextFilter', () {
    test('constructor should create instance with equals condition', () {
      final filter = TextFilter('Title', equals: 'Project X');
      expect(filter.property, equals('Title'));
      expect(filter.equals, equals('Project X'));
    });

    test('constructor should throw assertion error when multiple conditions are specified', () {
      expect(
        () => TextFilter('Title', equals: 'Project X', contains: 'Project'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('constructor should throw assertion error when no condition is specified', () {
      expect(
        () => TextFilter('Title'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('toMap should return correct map for string condition', () {
      final filter = TextFilter('Title', contains: 'Project');
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Title',
            'rich_text': {'contains': 'Project'},
          }));
    });

    test('toMap should return correct map for boolean condition', () {
      final filter = TextFilter('Title', isNotEmpty: true);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Title',
            'rich_text': {'is_not_empty': true},
          }));
    });

    test('toMap should return correct map for starts_with condition', () {
      final filter = TextFilter('Title', startsWith: 'Pro');
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Title',
            'rich_text': {'starts_with': 'Pro'},
          }));
    });

    test('toMap should return correct map for ends_with condition', () {
      final filter = TextFilter('Title', endsWith: 'X');
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Title',
            'rich_text': {'ends_with': 'X'},
          }));
    });

    test('toMap should return correct map for formula property', () {
      final filter = TextFilter('Title', contains: 'Project', isFormulaProperty: true);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Title',
            'formula': {
              'rich_text': {'contains': 'Project'},
            },
          }));
    });
  });
}
