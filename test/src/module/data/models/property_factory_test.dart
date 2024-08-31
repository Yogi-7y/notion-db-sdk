import 'package:core_y/core_y.dart';
import 'package:notion_db_sdk/src/module/data/models/property_factory.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/variants.dart';
import 'package:test/test.dart';

void main() {
  late PropertyFactory factory;

  setUp(() {
    factory = PropertyFactory();
  });

  group('PropertyFactory', () {
    test('throws ArgumentError when map is empty', () {
      final _mapLengthMustBe1 = isA<SerializationException>().having(
        (exception) => exception.exception,
        'message',
        equals('Map length must be 1'),
      );

      expect(() => factory({}), throwsA(_mapLengthMustBe1));
    });

    test('creates TextModel for rich_text type', () {
      final map = {
        'Description': {
          'id': 'abc123',
          'type': 'rich_text',
          'rich_text': [
            {
              'type': 'text',
              'text': {'content': 'This is a description'}
            }
          ],
        }
      };
      final property = factory(map);
      expect(property, isA<TextProperty>());
      expect(property.name, equals('Description'));
      expect(property.type, equals('rich_text'));
      expect(property.value, equals('This is a description'));
    });

    test(
      'creates TextModel for title type',
      () {
        final map = {
          'Name': {
            'id': 'def456',
            'type': 'title',
            'title': [
              {
                'type': 'text',
                'text': {'content': 'Page Title'}
              }
            ],
          }
        };

        final property = factory(map);
        expect(property, isA<TextProperty>());
        expect(property.name, equals('Name'));
        expect(property.type, equals('title'));
        expect(property.value, equals('Page Title'));
      },
      skip: 'This test is skipped because the implementation is not yet available',
    );

    test('creates NumberModel for number type', () {
      final map = {
        'Price': {
          'id': 'ghi789',
          'type': 'number',
          'number': 42,
        }
      };
      final property = factory(map);
      expect(property, isA<Number>());
      expect(property.name, equals('Price'));
      expect(property.type, equals('number'));
      expect(property.value, equals(42));
    });

    test('creates CheckboxModel for checkbox type', () {
      final map = {
        'Is Complete': {
          'id': 'jkl012',
          'type': 'checkbox',
          'checkbox': true,
        }
      };
      final property = factory(map);
      expect(property, isA<CheckboxProperty>());
      expect(property.name, equals('Is Complete'));
      expect(property.type, equals('checkbox'));
      expect(property.value, isTrue);
    });

    test('creates DateModel for date type', () {
      final map = {
        'Due Date': {
          'id': 'mno345',
          'type': 'date',
          'date': {'start': '2023-05-01'},
        }
      };
      final property = factory(map);
      expect(property, isA<Date>());
      expect(property.name, equals('Due Date'));
      expect(property.type, equals('date'));
      expect(property.value, equals(DateTime(2023, 5)));
    });

    test('creates PhoneNumberModel for phone_number type', () {
      final map = {
        'Contact': {
          'id': 'pqr678',
          'type': 'phone_number',
          'phone_number': '+1 (555) 123-4567',
        }
      };

      final property = factory(map);
      expect(property, isA<PhoneNumber>());
      expect(property.name, equals('Contact'));
      expect(property.type, equals('phone_number'));
      expect(property.value, equals('+1 (555) 123-4567'));
    });

    test('throws UnsupportedError for unsupported type', () {
      final map = {
        'Unsupported': {
          'id': 'vwx234',
          'type': 'unsupported_type',
        }
      };
      expect(() => factory(map), throwsA(isA<UnsupportedError>()));
    });
  });

  group('Formula', () {
    test('creates NumberModel for formula with number type', () {
      final map = {
        'Amount': {
          'id': 'HU%3DS',
          'type': 'formula',
          'formula': {
            'type': 'number',
            'number': 42,
          },
        },
      };
      final property = factory(map);
      expect(property, isA<Number>());
      expect(property.name, equals('Amount'));
      expect(property.type, equals('number'));
      expect(property.value, equals(42));
    });

    test('creates CheckboxModel for formula with boolean type', () {
      final map = {
        'Cold': {
          'id': 'I%7D%5Cl',
          'type': 'formula',
          'formula': {
            'type': 'boolean',
            'boolean': false,
          },
        },
      };
      final property = factory(map);
      expect(property, isA<CheckboxProperty>());
      expect(property.name, equals('Cold'));
      expect(property.type, equals('boolean'));
      expect(property.value, equals(false));
    });

    test('throws UnsupportedError for unsupported formula type', () {
      final map = {
        'Unsupported': {
          'id': 'XYZ789',
          'type': 'formula',
          'formula': <String, Object?>{
            'type': 'unsupported_type',
            'unsupported_type': 'some_value',
          },
        },
      };
      expect(() => factory(map), throwsA(isA<UnsupportedError>()));
    });

    test('handles nested formula properties correctly', () {
      final map = {
        'NestedFormula': {
          'id': 'NESTED123',
          'type': 'formula',
          'formula': <String, Object?>{
            'type': 'number',
            'number': 100,
          },
        },
      };
      final property = factory(map);
      expect(property, isA<Number>());
      expect(property.name, equals('NestedFormula'));
      expect(property.type, equals('number'));
      expect(property.value, equals(100));
    });

    test('preserves original property name in nested formula', () {
      final map = {
        'FormulaProperty': {
          'id': 'FP123',
          'type': 'formula',
          'formula': {
            'type': 'boolean',
            'boolean': true,
          },
        },
      };
      final property = factory(map);
      expect(property, isA<CheckboxProperty>());
      expect(property.name, equals('FormulaProperty'));
    });
  });

  group('Rollup property handling', () {
    test('creates NumberModel for rollup with array of numbers', () {
      final map = {
        'Price': <String, Object?>{
          'id': 'C%3DT%40',
          'type': 'rollup',
          'rollup': <String, Object?>{
            'type': 'array',
            'array': [
              {
                'type': 'number',
                'number': 42,
              }
            ],
            'function': 'show_original'
          }
        },
      };
      final property = factory(map);
      expect(property, isA<Number>());
      expect(property.name, equals('Price'));
      expect(property.type, equals('number'));
      expect(property.value, equals(42));
    });

    test('creates NumberModel for rollup with number', () {
      final map = {
        'Minutes': {
          'id': 'fZhC',
          'type': 'rollup',
          'rollup': {'type': 'number', 'number': 60, 'function': 'sum'}
        },
      };
      final property = factory(map);
      expect(property, isA<Number>());
      expect(property.name, equals('Minutes'));
      expect(property.type, equals('number'));
      expect(property.value, equals(60));
    });

    test('throws UnsupportedError for unsupported rollup type', () {
      final map = {
        'Unsupported': {
          'id': 'XYZ789',
          'type': 'rollup',
          'rollup': {
            'type': 'unsupported_type',
            'unsupported_type': 'some_value',
          },
        },
      };
      expect(() => factory(map), throwsA(isA<UnsupportedError>()));
    });
  });
}
