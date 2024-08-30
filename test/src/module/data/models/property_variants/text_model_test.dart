import 'package:notion_db_sdk/src/core/errors/exception.dart';
import 'package:notion_db_sdk/src/module/data/models/property_variants/text_model.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/variants.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  test(
    'throws InvalidMapLengthException when map has more than 1 key',
    () {
      final _map = {
        'Description': {
          'id': 'a%7BUf',
          'type': 'rich_text',
          'rich_text': [
            {
              'type': 'text',
              'text': {
                'content': 'A dark sky',
              },
            }
          ],
        },
        'Extra Field': {
          'id': 'extra',
          'type': 'rich_text',
          'rich_text': [
            {
              'type': 'text',
              'text': {
                'content': 'Extra content',
              },
            }
          ],
        },
      };

      expect(
        () => TextModel.fromMap(_map),
        throwsA(isA<InvalidMapLengthException>()),
      );
    },
  );

  test(
    'throws InvalidPropertyTypeException with correct expectedType when property type is invalid',
    () {
      final _map = {
        'Description': {
          'id': 'a%7BUf',
          'type': 'invalid_type', // Intentionally incorrect type
          'rich_text': [
            {
              'type': 'text',
              'text': {
                'content': 'A dark sky',
              },
            }
          ],
        },
      };
      expect(
        () async {
          try {
            TextModel.fromMap(_map);
          } catch (e) {
            if (e is InvalidPropertyTypeException) {
              expect(e.expectedType, 'rich_text');
              rethrow;
            }
          }
        },
        throwsA(isA<InvalidPropertyTypeException>()),
      );
    },
  );

  test(
    'convert json to text',
    () {
      final _map = {
        'Description': {
          'id': 'a%7BUf',
          'type': 'rich_text',
          'rich_text': [
            {
              'type': 'text',
              'text': {
                'content': 'A dark sky',
              },
            }
          ],
        },
      };

      final _text = TextModel.fromMap(_map);
      const _expectedResult = TextProperty(
        name: 'Description',
        id: 'a%7BUf',
        valueDetails: Value(value: 'A dark sky'),
      );

      expect(_text, isA<TextProperty>());
      expect(_text, _expectedResult);
    },
  );

  test(
    'handles empty rich_text array',
    () {
      final _map = {
        'Description': {
          'id': 'a%7BUf',
          'type': 'rich_text',
          'rich_text': <Map<String, Object?>>[],
        },
      };
      final _text = TextModel.fromMap(_map);

      const _expectedResult = TextProperty(
        name: 'Description',
        type: 'rich_text',
        id: 'a%7BUf',
        valueDetails: Value(value: ''),
      );

      expect(_text, isA<TextProperty>());
      expect(_text, _expectedResult);
    },
  );

  test(
    'handles multiple text segments in rich_text array',
    () {
      final _map = {
        'Description': {
          'id': 'a%7BUf',
          'type': 'rich_text',
          'rich_text': [
            {
              'type': 'text',
              'text': {
                'content': 'A dark sky',
              },
            },
            {
              'type': 'text',
              'text': {
                'content': ' with stars',
              },
            }
          ],
        },
      };
      final _text = TextModel.fromMap(_map);

      const _expectedResult = TextProperty(
        name: 'Description',
        type: 'rich_text',
        id: 'a%7BUf',
        valueDetails: Value(value: 'A dark sky with stars'),
      );

      expect(_text, isA<TextProperty>());
      expect(_text, _expectedResult);
    },
  );
}
