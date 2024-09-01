import 'package:notion_db_sdk/src/module/domain/entity/filters/checkbox_filter.dart';
import 'package:test/test.dart';

void main() {
  group('CheckboxFilter', () {
    test('constructor should create instance with equals condition', () {
      final filter = CheckboxFilter('Done', equals: true);
      expect(filter.property, equals('Done'));
      expect(filter.equals, isTrue);
      expect(filter.doesNotEqual, isNull);
    });

    test('constructor should create instance with doesNotEqual condition', () {
      final filter = CheckboxFilter('Done', doesNotEqual: false);
      expect(filter.property, equals('Done'));
      expect(filter.equals, isNull);
      expect(filter.doesNotEqual, isFalse);
    });

    test('constructor should throw assertion error when both conditions are specified', () {
      expect(
        () => CheckboxFilter('Done', equals: true, doesNotEqual: false),
        throwsA(isA<AssertionError>()),
      );
    });

    test('constructor should throw assertion error when no condition is specified', () {
      expect(
        () => CheckboxFilter('Done'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('toMap should return correct map for equals condition', () {
      final filter = CheckboxFilter('Done', equals: true);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Done',
            'checkbox': {'equals': true},
          }));
    });

    test('toMap should return correct map for doesNotEqual condition', () {
      final filter = CheckboxFilter('Done', doesNotEqual: false);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Done',
            'checkbox': {'does_not_equal': false},
          }));
    });

    test('toMap should only include the specified condition', () {
      final filter1 = CheckboxFilter('Done', equals: true);
      final map1 = filter1.toMap();
      expect(map1['checkbox'], containsPair('equals', true));
      expect(map1['checkbox'], isNot(contains('does_not_equal')));

      final filter2 = CheckboxFilter('Done', doesNotEqual: false);
      final map2 = filter2.toMap();
      expect(map2['checkbox'], containsPair('does_not_equal', false));
      expect(map2['checkbox'], isNot(contains('equals')));
    });

    test('toMap should return correct map for formula property', () {
      final filter = CheckboxFilter('Done', equals: true, isFormulaProperty: true);
      final map = filter.toMap();
      expect(
        map,
        equals(
          {
            'property': 'Done',
            'formula': {
              'checkbox': {'equals': true},
            },
          },
        ),
      );
    });
  });
}
