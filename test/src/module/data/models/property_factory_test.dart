import 'package:notion_db_sdk/src/module/data/models/property_factory.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/checkbox.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/date.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/number.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/phone_number.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/text.dart';
import 'package:test/test.dart';

void main() {
  group('PropertyFactory', () {
    late PropertyFactory factory;

    setUp(() {
      factory = PropertyFactory();
    });

    test('throws ArgumentError when map is empty', () {
      expect(() => factory({}), throwsA(isA<ArgumentError>()));
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
      expect(property, isA<Text>());
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
        expect(property, isA<Text>());
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
      expect(property, isA<Checkbox>());
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
}
