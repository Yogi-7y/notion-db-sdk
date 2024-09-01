import 'package:notion_db_sdk/src/module/domain/entity/filters/relation_filter.dart';
import 'package:test/test.dart';

void main() {
  group('RelationFilter', () {
    test('constructor should create instance with contains condition', () {
      final filter = RelationFilter('Related', contains: 'page_id_123');
      expect(filter.property, equals('Related'));
      expect(filter.contains, equals('page_id_123'));
    });

    test('constructor should create instance with doesNotContain condition', () {
      final filter = RelationFilter('Related', doesNotContain: 'page_id_456');
      expect(filter.property, equals('Related'));
      expect(filter.doesNotContain, equals('page_id_456'));
    });

    test('constructor should create instance with isEmpty condition', () {
      final filter = RelationFilter('Related', isEmpty: true);
      expect(filter.property, equals('Related'));
      expect(filter.isEmpty, isTrue);
    });

    test('constructor should create instance with isNotEmpty condition', () {
      final filter = RelationFilter('Related', isNotEmpty: true);
      expect(filter.property, equals('Related'));
      expect(filter.isNotEmpty, isTrue);
    });

    test('constructor should throw assertion error when multiple conditions are specified', () {
      expect(
        () => RelationFilter('Related', contains: 'page_id_123', isEmpty: true),
        throwsA(isA<AssertionError>()),
      );
    });

    test('constructor should throw assertion error when no condition is specified', () {
      expect(
        () => RelationFilter('Related'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('toMap should return correct map for contains condition', () {
      final filter = RelationFilter('Related', contains: 'page_id_123');
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Related',
            'relation': {'contains': 'page_id_123'},
          }));
    });

    test('toMap should return correct map for doesNotContain condition', () {
      final filter = RelationFilter('Related', doesNotContain: 'page_id_456');
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Related',
            'relation': {'does_not_contain': 'page_id_456'},
          }));
    });

    test('toMap should return correct map for isEmpty condition', () {
      final filter = RelationFilter('Related', isEmpty: true);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Related',
            'relation': {'is_empty': true},
          }));
    });

    test('toMap should return correct map for isNotEmpty condition', () {
      final filter = RelationFilter('Related', isNotEmpty: true);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Related',
            'relation': {'is_not_empty': true},
          }));
    });
  });
}
